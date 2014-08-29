require 'rubygems'
require 'bundler/setup'
require 'net/http'
require 'uri'

Bundler.require(:default)

post '/' do

  content_type :json

  text         = params[:text]
  user_name    = params[:user_name]
  channel_name = params[:channel_name]
  timestamp    = params[:timestamp]

  response = Slacker::Bot.handle(text, user_name, channel_name, timestamp)
  JSON.generate({text: response.join("\n")}) if response
end

get '/' do
  haml :index
end

module Slacker
  class Bot
    @@plugins = Array.new

    class <<self
      def plugins
        @@plugins
      end

      def register(plugin)
        @@plugins << plugin.new
      end

      def handle(text, user_name, channel_name, timestamp)
        response = Array.new
        return response if user_name == 'Slacker'

        @@plugins.each do |plugin|
          if /slacker\s(help|man)/ =~ text
            matches = /slacker\s(help|man)\s(.*)/.match(text)
            break if matches.nil?

            needs_help_with = matches.captures[1]

            if plugin.pattern =~ needs_help_with
              response << plugin.help unless plugin.help.nil?
            end
          elsif /slacker\s+#{plugin.pattern}/ =~ text
            r = plugin.respond(text, user_name, channel_name, timestamp)
            response << r unless r.nil?
          end
        end

        if /slacker\s(help|man)/ =~ text and not response.any?
          response << 'No help available for that command :('
        end

        return response
      end
    end 
  end

  class Plugin
    def pattern
      //
    end

    def handle(text, user_name, channel_name, timestamp)
      ''
    end

    def help
      ''
    end
  end

  Dir.glob('plugins/**/*.rb').each do |f|
    load f
  end
end


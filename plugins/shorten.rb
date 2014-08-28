require 'uri'
require 'googl'

module Slacker
  class Shorten < Plugin

    @@responses = [
      'All done!',
      'Easy-peasy!',
      'Here it is:',
      'No problem!',
      'Et voilà !'
    ]

    def help
      'Usage: slacker shorten [url] -> a goo.gl shortened version of that url'
    end

    def pattern
      /shorten/
    end

    def respond (text, user_name, channel_name, timestamp)
      return nil unless text.include? 'http'

      longUrl = text[text.index('http')..text.length()].tr('<>','')
      googl = Googl.shorten(longUrl)

      return @@responses.sample + ' ' + googl.short_url 
    end

    Bot.register(Shorten)
  end
end

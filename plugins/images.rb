require 'google-search'

module Slacker
  class Images < Plugin
    def help
      'Usage: slacker image me [query] -> the first image returned from Google Images'
    end

    def pattern
      /image\sme\s(.*)/i
    end

    def respond (text, user_name, channel_name, timestamp)
      query  = pattern.match(text).captures[0]
      images = Google::Search::Image.new(query: query)

      if images.any?
        "Voici #{query} : #{images.first}"
      else
        "Je n'ai pas trouvé #{query} :("
      end
    end

    Bot.register(Images)
  end
end

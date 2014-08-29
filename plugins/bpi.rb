module Slacker

  class BPI< Plugin
    def help
      'Usage: slacker bpi -> slackers returns the current Bitcoin Price Index from www.coindesk.com'
    end

    def pattern
      /bpi/
    end

    def respond(text, user_name, channel_name,timestamp)
      url = 'http://api.coindesk.com/v1/bpi/currentprice.json'
      resp = Net::HTTP.get_response(URI.parse(url))

      data = JSON.parse(resp.body)
      return data['bpi']['USD']['rate']+"USD"
    end

    Bot.register(BPI)

  end
end

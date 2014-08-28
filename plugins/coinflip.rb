module Slacker
  class CoinFlip < Plugin
    def help
      'Usage: slacker flip a coin -> heads/tails'
    end

    def pattern
      /(flip\sa\scoin)|(heads\sor\stails)/
    end

    def respond (text, user_name, channel_name, timestamp)
      heads = [true, false].sample
      return (heads ? 'face' : 'pile') << ' !'
    end

    Bot.register(CoinFlip)
  end
end

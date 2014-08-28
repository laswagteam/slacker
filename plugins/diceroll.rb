module Slacker
  class DiceRoll < Plugin
    def help
      'Usage: slacker roll a dice -> slacker will roll a six-sided dice.'
    end

    def pattern
      /lance\sun\sdé/
    end

    def respond (text, user_name, channel_name, timestamp)
      result = rand(6) + 1
      return "J'ai obtenu un #{result}!"
    end

    Bot.register(DiceRoll)
  end
end

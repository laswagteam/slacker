require 'to_lang'

module Slacker
  class Translate < Plugin
    @@languages  = {
      "af" => "Afrikaans",
      "sq" => "Albanian",
      "ar" => "Arabic",
      "az" => "Azerbaijani",
      "eu" => "Basque",
      "bn" => "Bengali",
      "be" => "Belarusian",
      "bg" => "Bulgarian",
      "ca" => "Catalan",
      "zh-CN" => "Simplified Chinese",
      "zh-TW" => "Traditional Chinese",
      "hr" => "Croatian",
      "cs" => "Czech",
      "da" => "Danish",
      "nl" => "Dutch",
      "en" => "Anglais",
      "eo" => "Esperanto",
      "et" => "Estonian",
      "tl" => "Filipino",
      "fi" => "Finnish",
      "fr" => "Français",
      "gl" => "Galician",
      "ka" => "Georgian",
      "de" => "German",
      "el" => "Greek",
      "gu" => "Gujarati",
      "ht" => "Haitian Creole",
      "iw" => "Hebrew",
      "hi" => "Hindi",
      "hu" => "Hungarian",
      "is" => "Icelandic",
      "id" => "Indonesian",
      "ga" => "Irish",
      "it" => "Italian",
      "ja" => "Japanese",
      "kn" => "Kannada",
      "ko" => "Korean",
      "la" => "Latin",
      "lv" => "Latvian",
      "lt" => "Lithuanian",
      "mk" => "Macedonian",
      "ms" => "Malay",
      "mt" => "Maltese",
      "no" => "Norwegian",
      "fa" => "Persian",
      "pl" => "Polish",
      "pt" => "Portuguese",
      "ro" => "Romanian",
      "ru" => "Russian",
      "sr" => "Serbian",
      "sk" => "Slovak",
      "sl" => "Slovenian",
      "es" => "Spanish",
      "sw" => "Swahili",
      "sv" => "Swedish",
      "ta" => "Tamil",
      "te" => "Telugu",
      "th" => "Thai",
      "tr" => "Turkish",
      "uk" => "Ukrainian",
      "ur" => "Urdu",
      "vi" => "Vietnamese",
      "cy" => "Welsh",
      "yi" => "Yiddish"
    }

    def help
      'Usage: slacker translate [text-to-translate] from [source-lang] to [target-lang] -> translated version of your text!'
    end

    def pattern
      choices = @@languages.flatten.join '|'
      /traduits\s('|")(.+)('|")\sdu\s(#{choices})\sau\s(#{choices})/i
    end

    def respond (text, user_name, channel_name, timestamp)
      matches = pattern.match(text)

      source = matches.captures[3]
      target = matches.captures[4]

      if @@languages[source].nil?
        source = @@languages.key(source.downcase.capitalize)
      end

      if @@languages[target].nil?
        target = @@languages.key(target.downcase.capitalize)
      end

      if (source.nil? or target.nil?)
        return 'Je ne connais pas ce langage !'
      else
        ToLang.start(ENV['SLACKER_TRANSLATE_API_KEY'])

        begin
          to_translate = matches.captures[1]
          translated = to_translate.translate(target, :from => source)

          '\'' << to_translate << '\' signifie \'' << translated << '\' en ' << @@languages[target]
        rescue RuntimeError => e
          'Change ta TRANSLATE_API_KEY mofo !'
        end
      end
    end

    Bot.register(Translate)
  end
end

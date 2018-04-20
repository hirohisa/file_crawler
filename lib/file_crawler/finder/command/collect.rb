module FileCrawler

  class Regex
    attr_accessor :regexp_start, :regexp_end

    def initialize(regexp_start, regexp_end)
      @regexp_start = regexp_start
      @regexp_end = regexp_end
    end

    def pattern
      /#{Regexp.escape(regexp_start)}([^#{Regexp.escape(regexp_end)}]+)#{Regexp.escape(regexp_end)}/
    end

    def to_s
      "#<#{self.class.name}: start='#{regexp_start}', end='#{regexp_end}'"
    end
  end


end

module FileCrawler::Finder::Command

  module Collect
    include Base

    attr_accessor :regexs

    def regexs
      @regexs ||= []
    end

    def collect(options={})
      tap {
        if options[:regexs].is_a?(Array)
          options[:regexs].each {|o|
            regexs << FileCrawler::Regex.new(o[0], o[1]) if o.size == 2
          }
        end

        @collections = Organizer.new.run(@files, regexs)
      }
    end

    class Organizer

      def run(filepaths, regexs)
        hash = {}

        filepaths.each {|filepath|
          filename = File.basename(filepath)
          term = decide_index(filename, regexs)
          hash[term] ||= []
          hash[term] << filepath
        }

        hash
      end

      def decide_index(string, regexs=[])
        if !regexs.empty?
          regexs.each {|regex|
            return $1.strip unless regex.pattern.match(string).nil?
          }
        end

        pattern = /[\p{Hiragana}|\p{Katakana}|\p{Han}|[a-zA-Z0-9]ー 　]+/
        result = string.strip.scan(pattern).first
        return result.strip unless result.nil?

        string.strip
      end
    end

  end

end

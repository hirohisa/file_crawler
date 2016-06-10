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

  class Finder
    module Command
      module Collect

        attr_accessor :regexs

        def regexs
          @regexs ||= []
        end

        def collect(conditions = {})
          tap {
            @rows = collect_into_filename(@rows)
          }
        end

        def collect_into_filename(file_paths)
          hash = {}

          file_paths.each {|file_path|
            filename = File.basename(file_path)
            term = decide_index_for_collect(filename)
            hash[term] ||= []
            hash[term] << file_path
          }

          hash
        end

        def decide_index_for_collect(string)
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
end

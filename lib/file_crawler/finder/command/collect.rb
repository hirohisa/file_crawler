module FileCrawler
  class Regex
    attr_accessor :regexp_start, :regexp_end

    def initialize(regexp_start, regexp_end)
      @regexp_start = regexp_start
      @regexp_end = regexp_end
    end

    def pattern
      /#{Regexp.escape(regexp_start)}(.+)#{Regexp.escape(regexp_end)}/
    end
  end

  class Finder
    module Command
      module Collect

        def regexs
          @regexs ||= []
        end

        def collect(file_paths, conditions = {})
          collection = collect_into_filename(file_paths)

          collection
        end

        def decide_index_for_collect(string)
          if !regexs.empty?
            regexs.each {|regex|
              return $1 unless regex.pattern.match(string).nil?
            }
          end

          pattern = /[\p{Hiragana}|\p{Katakana}|\p{Han}|[a-zA-Z0-9]ー 　]+/
          return string.strip.scan(pattern).first
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

      end
    end
  end
end

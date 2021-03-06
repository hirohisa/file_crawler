module FileCrawler::Finder::Command

  module Search
    include Base

    def search(path, options={})
      tap {
        @directories = search_directories(path, options)
      }
    end

    def search_directories(path, options={})
      result = []
      cmd = "find #{path} -type d"
      if options[:maxdepth] && options[:maxdepth] > 0
        cmd = "find #{path} -maxdepth #{options[:maxdepth]} -type d"
      end
      if options[:grep]
        cmd += "| grep #{options[:grep].inspect}"
      end

      exec(cmd).each_line {|item|
        item.chomp!
        valid = true
        if options[:exclude_invisible_file]
          filename = File.basename(item)
          valid = !filename.start_with?('.')
        end
        result << item if valid
      }

      result
    end

  end

end

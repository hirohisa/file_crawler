
class FileCrawler::Finder

  module Command

    module Base

      def exec(str)
        `#{str}`
      end

    end

  end

end

require_relative 'command/collect'
require_relative 'command/move'
require_relative 'command/search'

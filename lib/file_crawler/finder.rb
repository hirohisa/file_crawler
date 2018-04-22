require_relative 'finder/command'

module FileCrawler

  class Finder
    attr_accessor :directories, :collections

    include Command::Collect
    include Command::Move
    include Command::Search

    def initialize
      @rows = []
    end
  end

end

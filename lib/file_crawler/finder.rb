require_relative 'finder/command'

module FileCrawler

  class Finder
    attr_reader :directories, :dirs, :collections

    include Command::Collect
    include Command::Move
    include Command::Search

    def initialize
      @rows = []
    end

    def dirs
      @directories
    end
  end

end

require_relative 'finder/command'

module FileCrawler

  class Finder
    attr_accessor :files, :collections

    include Command::Collect
    include Command::Move
    include Command::Search

    def initialize
      @rows = []
      @collections = []
    end
  end

end

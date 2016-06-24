require 'spec_helper'

describe FileCrawler::Finder::Command::Resemble do

  it 'resembles' do

    collection = {
      'a': ['/path1/unique_directory', '/path1/directory', '/path1/directory (1)', '/path1/directory (2)'],
    }

    finder = FileCrawler::Finder.new
    finder.instance_variable_set(:@rows, collection)
    finder.resemble()

    expected = [
      '/path1/directory (1)', '/path1/directory (2)'
    ]

    expect(finder.rows).to eq expected
  end

end

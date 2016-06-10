require 'spec_helper'

describe FileCrawler::Finder::Command::Collect do

  it 'collects in file paths' do
    allow(Dir).to receive(:entries).and_return([])

    path = '/path'
    files = [
      'path1', 'path2'
    ]
    allow(Dir).to receive(:entries).with(path).and_return(files)

    path1 = '/path/path1'
    files1 = [
      '[abcd] defg', '[あい] うえお', 'test 123', '[123] 456',
    ]
    allow(Dir).to receive(:entries).with(path1).and_return(files1)

    path2 = '/path/path2'
    files2 = [
      '[abcd] defg', '[あ] いうえお'
    ]
    allow(Dir).to receive(:entries).with(path2).and_return(files2)
    allow(File).to receive(:directory?).and_return(true)

    actual = FileCrawler.collect(path)

    expected = {
      'abcd': ['/path/path1/[abcd] defg', '/path/path2/[abcd] defg'],
      'test 123': ['/path/path1/test 123'],
      '123': ['/path/path1/[123] 456'],
      'あ': ['/path/path2/[あ] いうえお'],
      'あい': ['/path/path1/[あい] うえお'],
    }.map {|k,v|
      [k.to_s, v]
    }.to_h

    expect(actual.keys.size).to eq expected.keys.size
    actual.each {|actual_key, actual_value|
      expect(actual_value.sort).to eq expected[actual_key].sort
    }
  end

  it 'splits with symbols' do
    finder = FileCrawler::Finder.new

    result = finder.decide_index_for_collect('[TEST] test')
    expect(result).to eq 'TEST'

    result = finder.decide_index_for_collect('【あいー】 うえお')
    expect(result).to eq 'あいー'

    result = finder.decide_index_for_collect('test2test')
    expect(result).to eq 'test2test'

    result = finder.decide_index_for_collect('t；e,s*t')
    expect(result).to eq 't'

    result = finder.decide_index_for_collect('   [test1] test2')
    expect(result).to eq 'test1'

    result = finder.decide_index_for_collect('---')
    expect(result).to eq '---'

    finder.regexs = [ FileCrawler::Regex.new('(', ')') ]
    result = finder.decide_index_for_collect('t(e_s)t')
    expect(result).to eq 'e_s'

    finder.regexs = [ FileCrawler::Regex.new('[', ']') ]
    result = finder.decide_index_for_collect('(abc) [def] ghij [klmn]')
    expect(result).to eq 'def'
  end

end

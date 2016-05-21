require 'spec_helper'

describe FileCrawler::Finder::Command::Collect do

  it 'collects in file paths' do
    path1 = '/path1'
    files1 = [
      '[abcd] defg', '[あい] うえお', 'test 123', '[123] 456',
    ]
    allow(Dir).to receive(:entries).with(path1).and_return(files1)

    path2 = '/path2'
    files2 = [
      '[abcd] defg', '[あ] いうえお'
    ]
    allow(Dir).to receive(:entries).with(path2).and_return(files2)
    allow(File).to receive(:directory?).and_return(true)

    actual = FileCrawler.collect([path1, path2])

    expected = {
      'abcd': ['/path1/[abcd] defg', '/path2/[abcd] defg'],
      'defg': ['/path1/[abcd] defg', '/path2/[abcd] defg'],
      'test': ['/path1/test 123'],
      '123': ['/path1/test 123', '/path1/[123] 456'],
      '456': ['/path1/[123] 456'],
      'あ': ['/path2/[あ] いうえお'],
      'あい': ['/path1/[あい] うえお'],
      'いうえお': ['/path2/[あ] いうえお'],
      'うえお': ['/path1/[あい] うえお'],
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

    result = finder.split_for_collect('[TEST] test')
    expect(result).to eq ['TEST', 'test']

    result = finder.split_for_collect('【あいー】 うえお')
    expect(result).to eq ['あいー', 'うえお']

    result = finder.split_for_collect('t(e_s.t')
    expect(result).to eq ['t', 'e', 's', 't']

    result = finder.split_for_collect('t！e？s　t')
    expect(result).to eq ['t', 'e', 's', 't']

    result = finder.split_for_collect('t；e,s*t')
    expect(result).to eq ['t', 'e', 's', 't']

    result = finder.split_for_collect('test2test')
    expect(result).to eq ['test2test']
  end

end

require 'spec_helper'

describe FileCrawler::Finder::Command::Organize do

  it 'organizes' do
    allow(Dir).to receive(:entries).and_return([])

    path1 = '/path1'
    files1 = [
      '[abcd] defg', '[あい] うえお', 'test 123', '[123] 456',
    ]
    allow(Dir).to receive(:entries).with(path1).and_return(files1)

    path2 = '/path2'
    files2 = [
      '[abcd] defge', '[あ] いうえお'
    ]
    allow(Dir).to receive(:entries).with(path2).and_return(files2)
    allow(File).to receive(:directory?).and_return(true)

    destination = '/var'

    allow(FileUtils).to receive(:mv).and_return(nil)

    result = FileCrawler.organize([path1, path2], destination, unique: true)

    expected = [
      '/var/123/test 123',
      '/var/123/[123] 456',
      '/var/abcd/[abcd] defg',
      '/var/abcd/[abcd] defge',
      '/var/あ/[あ] いうえお',
      '/var/あい/[あい] うえお',
    ]

    expect(result.size).to eq expected.size
    result.each_with_index {|item, index|
      expect(item).to eq expected[index]
    }
  end

end

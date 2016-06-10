require 'spec_helper'

describe FileCrawler::Finder::Command::Move do

  it 'moves a directory to destination' do
    path = '/tmp'
    destination = '/var'
    files = [
      '.', '..', '.git', 'file', 'directory', 'extension.jpg',
    ]

    allow(Dir).to receive(:entries).and_return([])
    allow(Dir).to receive(:entries).with(path).and_return(files)
    allow(File).to receive(:directory?).and_return(false)
    allow(File).to receive(:directory?).with('/tmp/directory').and_return(true)
    allow(File).to receive(:directory?).with('/var').and_return(true)

    allow(FileUtils).to receive(:mv).and_return(nil)

    result = FileCrawler.move(path, destination)

    expect(result[0]).to eq destination + '/' + files[4] # /var/directory
  end

  it 'moves directories with numbering when same name directory already exist in destination' do
    path = '/tmp'
    destination = '/var'
    files = [
      'directory', 'directory1'
    ]
    allow(Dir).to receive(:entries).and_return([])
    allow(Dir).to receive(:entries).with(path).and_return(files)
    allow(File).to receive(:directory?).and_return(true)
    allow(File).to receive(:exist?).and_return(false)
    allow(File).to receive(:exist?).with('/var').and_return(true)
    allow(File).to receive(:exist?).with('/var/directory').and_return(true)
    allow(File).to receive(:exist?).with('/var/directory (1)').and_return(true)

    allow(FileUtils).to receive(:mv).and_return(nil)

    result = FileCrawler.move(path, destination, numbering: true)

    expect(result[0]).to eq destination + '/' + files[1] # /var/directory1
    expect(result[1]).to eq destination + '/' + "#{files[0]} (2)"  # /var/directory (2)
  end

end

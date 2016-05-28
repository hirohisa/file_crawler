require 'spec_helper'

describe FileCrawler::Finder::Command::Move do

  it 'moves a directory to destination' do
    path = '/tmp'
    destination = '/var'
    files = [
      '.', '..', '.git', 'file', 'directory', 'extension.jpg',
    ]
    allow(Dir).to receive(:entries).with(path).and_return(files)
    allow(File).to receive(:directory?).and_return(false)
    allow(File).to receive(:directory?).with('/tmp/directory').and_return(true)
    allow(File).to receive(:directory?).with('/var').and_return(true)

    allow(FileUtils).to receive(:mv).and_return(nil)

    result = FileCrawler.move(path, destination)

    expect(result[0]).to eq destination + '/' + files[4] # /var/directory
  end

  it 'moves directories that have jpg images to destination' do
    path = '/tmp'
    files = [
      '.', '..', '.git', 'file', 'directory', 'extension.jpg',
    ]
    allow(Dir).to receive(:entries).with(path).and_return(files)
    allow(File).to receive(:directory?).and_return(false)
    allow(File).to receive(:directory?).with('/tmp/directory').and_return(true)

    subpath = '/tmp/directory'
    subfiles = [
      '.', '..', 'file', 'extension.jpg',
    ]
    allow(Dir).to receive(:entries).with(subpath).and_return(subfiles)

    destination = '/var'

    allow(File).to receive(:directory?).and_return(false)
    allow(File).to receive(:directory?).with('/tmp/directory').and_return(true)
    allow(File).to receive(:directory?).with('/var').and_return(true)

    allow(FileUtils).to receive(:mv).and_return(nil)

    result = FileCrawler.move(path, destination, extension_in_directory: ['jpg'])

    expect(result[0]).to eq destination + '/' + files[4] # /var/directory
  end

  it 'moves directories when same name directory already exist in destination' do
    path = '/tmp'
    destination = '/var'
    files = [
      '.', '..', '.git', 'file', 'directory', 'extension.jpg',
    ]
    allow(Dir).to receive(:entries).with(path).and_return(files)
    allow(File).to receive(:directory?).and_return(false)
    allow(File).to receive(:directory?).with('/tmp/directory').and_return(true)
    allow(File).to receive(:directory?).with('/var').and_return(true)
    allow(File).to receive(:exist?).and_return(false)
    allow(File).to receive(:exist?).with('/var').and_return(true)
    allow(File).to receive(:exist?).with('/var/directory').and_return(true)

    allow(FileUtils).to receive(:mv).and_return(nil)

    result = FileCrawler.move(path, destination)

    expect(result[0]).to eq path + '/' + files[4] # /tmp/directory
  end

  it 'moves directories with numbering when same name directory already exist in destination' do
    path = '/tmp'
    destination = '/var'
    files = [
      'directory', 'directory1'
    ]
    allow(Dir).to receive(:entries).with(path).and_return(files)
    allow(File).to receive(:directory?).and_return(true)
    allow(File).to receive(:exist?).and_return(false)
    allow(File).to receive(:exist?).with('/var').and_return(true)
    allow(File).to receive(:exist?).with('/var/directory').and_return(true)

    allow(FileUtils).to receive(:mv).and_return(nil)

    result = FileCrawler.move(path, destination, numbering: true)

    expect(result[0]).to eq destination + '/' + files[1] # /var/directory1
    expect(result[1]).to eq destination + '/' + "#{files[0]} (1)"  # /var/directory (1)
  end

  it 'moves directories when destination is child directory' do
    path = '/tmp'
    destination = '/tmp/destination'
    files = [
      '.', '..', '.git', 'file', 'directory', 'destination', 'extension.jpg',
    ]
    allow(Dir).to receive(:entries).with(path).and_return(files)
    allow(File).to receive(:directory?).and_return(false)
    allow(File).to receive(:directory?).with('/tmp/directory').and_return(true)
    allow(File).to receive(:directory?).with('/tmp/destination').and_return(true)

    allow(FileUtils).to receive(:mv).and_return(nil)

    result = FileCrawler.move(path, destination)

    expect(result[0]).to eq destination + '/' + files[4] # /tmp/destination/directory
    expect(result[1]).to eq destination # /tmp/destination
  end

end

# FileCrawler

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'file_crawler'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install file_crawler

## Usage

- Create Instance

```ruby
finder = FileCrawler::Finder.new
```

- Find directories

```ruby
path = '.'

# stored `files`
finder.search(path)
p finder.files #=> ["./bin", "./lib", "./spec", ...]

finder.search(path, maxdepth: 1)
p finder.files #=> ["./bin", "./lib", "./spec"]

finder.search(path, maxdepth: 1, grep: 'sample')
p finder.files #=> []

```

- Create groups per label decided by file name

```ruby
# collect use `files`
# files = ['/path/path1/[abcd] defg', '/path/path2/(abcd) defg', '/path/path1/test 123', ...
finder.collect(regexs: ['[]', '()'])
p finder.collections
#=> { 'abcd': ['/path/path1/[abcd] defg', '/path/path2/(abcd) defg'], 'test 123': ['/path/path1/test 123'], ... }
```

- Move directory to destination

```ruby
# move use `files` or `collections`
# files = #=> ["./bin", "./lib", ...]
destination = '/var'
finder.move(destination)

# ensure destination
# [ [from, to], ... ]
p finder.targets #=> [["./bin", "/var/bin"] , ["./lib", "/var/lib"], ...]

# command output
p finder.output_mv #=> [ "mv ./bin /var/bin", "mv ./lib /var/lib", ...]

# run
finder.move(destination, dry_run: false)
```

# finder.search(source, grep: 'sample').collect(regexs: ['[]']).move(destination)


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hirohisa/file_crawler.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

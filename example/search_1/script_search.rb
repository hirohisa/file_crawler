$LOAD_PATH.unshift File.expand_path('../../../lib', __FILE__)
require 'file_crawler'

root = Dir.getwd # repository's root directory
directory = root + '/example/search_1'
result = FileCrawler.search(directory)

puts result

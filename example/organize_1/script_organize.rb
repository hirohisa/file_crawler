$LOAD_PATH.unshift File.expand_path('../../../lib', __FILE__)
require 'file_crawler'

root = Dir.getwd # repository's root directory
directory = root + '/example/organize_1/data/source'
destination = root + '/example/organize_1/data/destination'
FileCrawler.organize([directory], destination)

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'ar_shard'

require 'bundler/setup'
Bundler.require(:default)
require 'minitest/autorun'
require 'minitest/pride'
require 'fileutils'
require 'sqlite3'
require 'support'

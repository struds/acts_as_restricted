require 'rubygems'
require 'spec'
require 'active_record'

current_dir = File.dirname(__FILE__)
require "#{current_dir}/../lib/acts_as_restricted"
require "#{current_dir}/../init"
require "#{current_dir}/models/item"
require "#{current_dir}/models/group"
 
config = YAML::load(IO.read(current_dir + '/database.yml'))
ActiveRecord::Base.logger = Logger.new(current_dir + "/debug.log")
ActiveRecord::Base.establish_connection(config['restricted_test'])
load(current_dir + "/schema.rb")

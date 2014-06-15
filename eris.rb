#!/usr/bin/env ruby
# std lib
require 'json'

# gems
require 'sinatra'
require 'c3d'
require 'haml'

# this app
Dir[File.dirname(__FILE__) + '/bylaws/*.rb'].each {|file| require file }

get '/' do
  haml :index, layout: :index
end
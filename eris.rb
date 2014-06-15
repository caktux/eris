#!/usr/bin/env ruby
# std lib
require 'json'

# gems
require 'sinatra'
require 'c3d'

# this app
Dir[File.dirname(__FILE__) + '/bylaws/*.rb'].each {|file| require file }

C3D::SetupC3D.new

C3D::ConnectTorrent.supervise_as :puller, {
    username: ENV['TORRENT_USER'],
    password: ENV['TORRENT_PASS'],
    url:      ENV['TORRENT_RPC'] }
C3D::ConnectEth.supervise_as :eth, :cpp

# todo, need to trap_exit on these actors if they crash
$puller = Celluloid::Actor[:puller]
$eth    = Celluloid::Actor[:eth]

C3D::Utility.save_key

get '/' do
  "Hello, world"
end
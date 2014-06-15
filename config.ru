# Startup
require 'c3d'
require './eris'
require 'bundler'
require 'sprockets'

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

$key = $eth.get_key

map '/assets' do
  environment = Sprockets::Environment.new
  # necessary so bootstrap glyphicons will properly load
  environment.append_path 'assets/scripts/bootstrap/dist'
  environment.append_path 'assets'
  run environment
end

use Rack::ShowExceptions
run Sinatra::Application
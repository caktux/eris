# Startup
# std lib
require 'json'

# gems
require 'bundler'
require 'sinatra'
require 'sprockets'
require 'c3d'
require 'epm'
require 'haml'
require './app/eris'

# this app
Dir[File.dirname(__FILE__) + '/bylaws/*.rb'].each {|file| require file }

ERIS_REPO = 'https://github.com/project-douglas/eris.git'

C3D::SetupC3D.new
C3D::ConnectTorrent.supervise_as :puller, {
    username: ENV['TORRENT_USER'],
    password: ENV['TORRENT_PASS'],
    url:      ENV['TORRENT_RPC'] }

C3D::ConnectEth.supervise_as :eth, :cpp
C3D::Utility.save_key
$key = Celluloid::Actor[:eth].get_key

def get_latest_doug
  log_file = File.join(ENV['HOME'], '.epm', 'deployed-log.csv')
  begin
    log  = File.read log_file
    doug = log.split("\n").map{|l| l.split(',')}.select{|l| l[0] == ("Doug" || "DOUG" || "doug")}[-1][-1]
  rescue
    doug = '0x'
  end
  doug_check = Celluloid::Actor[:eth].get_storage_at doug, '0x10'
  if doug_check != '0x'
    return doug
  else
    return nil
  end
end

$doug = get_latest_doug

# C3D.start

map '/assets' do
  environment = Sprockets::Environment.new
  environment.append_path 'app/assets/scripts/bootstrap/dist'
  environment.append_path 'app/assets'
  run environment
end

use Rack::ShowExceptions
run Sinatra::Application
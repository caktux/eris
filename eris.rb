#!/usr/bin/env ruby
# std lib
require 'json'

# gems
require 'sinatra'
require 'c3d'
require 'haml'

# this app
Dir[File.dirname(__FILE__) + '/bylaws/*.rb'].each {|file| require file }

def address_guard contract
  contract = "0x#{contract}" unless contract[0..1] == '0x'
  contract
end

def find_the_peak contract
  lineage  = []
  parent   = $eth.get_storage_at contract, '0x14'
  p "parent: " + parent
  until parent == '0x'
    p "parent: " + parent
    lineage << parent
    child  = parent
    parent = $eth.get_storage_at parent, '0x14'
    break if child == parent
  end
  return lineage
end

def get_dougs_storage position
  unless position[0..1] == '0x'
    position = EPM::HexData.construct_data [position]
  end
  return $eth.get_storage_at $doug, position
end

before do
  print "[ERIS::#{Time.now.strftime( "%F %T" )}] Params Recieved >>\t" + params.inspect + "\n"
  print "[ERIS::#{Time.now.strftime( "%F %T" )}] Request >>\t\t" + request.body.read + "\n"
  # if $doug == nil
  #   redirect to('/set_doug')
  # end
end

get '/' do
  haml :index, layout: :index
end

get '/discuss' do
  # display swarum top LL
  @swarum = get_dougs_storage 'swarum'
  haml :discuss
end

get '/discuss/:contract' do
  contract = params[:contract]
  contract = address_guard contract
  contents = C3D::Assemble.new contract
  lineage = find_the_peak contract
  response = { 'lineage' => lineage, 'content' => contents.content }.to_json
end

post '/discuss/:contract/new_topic' do
  request.body.rewind
  request_from_ui = JSON.parse request.body.read
  topic = CreateTopic.new request_from_ui['content'], get_dougs_storage('BLWCTopic'), params[:contract]
  if topic.topic_id != ('0x' || nil )
    result = true
  else
    result = false
  end
  content_type :json
  response = { 'success' => result, 'result' => topic.topic_id }.to_json
end

post '/discuss/:contract/new_thread' do
  request.body.rewind
  request_from_ui = JSON.parse request.body.read
  thread = CreateThread.new request_from_ui['content'], get_dougs_storage('BLWCThread'), params[:contract]
  if thread.thread_id != ('0x' || nil )
    result = true
  else
    result = false
  end
  content_type :json
  response = { 'success' => result, 'result' => thread.thread_id }.to_json
end

post '/discuss/:contract/new_post' do
  request.body.rewind
  request_from_ui = JSON.parse request.body.read
  post = PostToThread.new request_from_ui['content'], get_dougs_storage('BLWPostTT'), params[:contract]
  if post.post_id != ('0x' || nil )
    result = true
  else
    result = false
  end
  content_type :json
  response = { 'success' => result, 'result' => post.post_id }.to_json
end

post '/discuss/:contract/upvote' do
  request.body.rewind
  request_from_ui = JSON.parse request.body.read
  post = VotePost.new params[:contract], 'upvote', get_dougs_storage('BLWVoteUpDown')
  if post.vote_count != ('0x' || nil )
    result = true
  else
    result = false
  end
  content_type :json
  response = { 'success' => result, 'result' => post.vote_count }.to_json
end

post '/discuss/:contract/downvote' do
  request.body.rewind
  request_from_ui = JSON.parse request.body.read
  post = VotePost.new params[:contract], 'downvote', get_dougs_storage('BLWVoteUpDown')
  if post.vote_count != ('0x' || nil )
    result = true
  else
    result = false
  end
  content_type :json
  response = { 'success' => result, 'result' => post.vote_count }.to_json
end

get '/moderate' do
  haml :moderate
end

get '/moderate/:contract' do
  contract = params[:contract]
  contract = address_guard contract
  contents = C3D::Assemble.new contract
  lineage  = find_the_peak contract
  content_type :json
  response = { 'lineage' => lineage, 'content' => contents.content }.to_json
end

post '/moderate/:contract/flag' do
  request.body.rewind
  request_from_ui = JSON.parse request.body.read
  post = FlagPost.new request_from_ui['contract'], get_dougs_storage('BLWFlagPost'), params[:contract]
  if post.added == true
    result = true
  else
    result = false
  end
  content_type :json
  response = { 'success' => result, 'result' => post.added }.to_json
end

post '/moderate/:contract/remove_flag' do
  request.body.rewind
  request_from_ui = JSON.parse request.body.read
  post = RemoveFlag.new request_from_ui['contract'], get_dougs_storage('BLWRemoveFlag'), params[:contract]
  if post.removed == true
    result = true
  else
    result = false
  end
  content_type :json
  response = { 'success' => result, 'result' => post.removed }.to_json
end

post '/moderate/:contract/promote' do
  request.body.rewind
  request_from_ui = JSON.parse request.body.read
  post = PromotePost.new request_from_ui['contract'], get_dougs_storage('BLWPromotePost'), params[:contract]
  if post.added == true
    result = true
  else
    result = false
  end
  content_type :json
  response = { 'success' => result, 'result' => post.added }.to_json
end

post '/moderate/:contract/remove_promotion' do
  request.body.rewind
  request_from_ui = JSON.parse request.body.read
  post = RemovePromoted.new request_from_ui['contract'], get_dougs_storage('BLWRemovePromoted'), params[:contract]
  if post.removed == true
    result = true
  else
    result = false
  end
  content_type :json
  response = { 'success' => result, 'result' => post.removed }.to_json
end

post '/moderate/:contract/blacklist' do
  request.body.rewind
  request_from_ui = JSON.parse request.body.read
  post = BlacklistPost.new request_from_ui['contract'], get_dougs_storage('BLWBlacklist'), params[:contract]
  if post.added == true
    result = true
  else
    result = false
  end
  content_type :json
  response = { 'success' => result, 'result' => post.added }.to_json
end

get '/vote' do
  haml :vote
end

get '/vote/:contract' do
  contract = params[:contract]
  contract = address_guard contract
  contents = C3D::Assemble.new contract
  lineage = find_the_peak contract
  response = { 'lineage' => lineage, 'content' => contents.content }.to_json
end

post '/vote/:contract/endorse' do
  request.body.rewind
  request_from_ui = JSON.parse request.body.read
  # result = C3D::Settings.set_settings request_from_ui
  content_type :json
  response = { 'success' => result }.to_json
end

post '/vote/:contract/vote' do
  request.body.rewind
  request_from_ui = JSON.parse request.body.read
  # result = C3D::Settings.set_settings request_from_ui
  content_type :json
  response = { 'success' => result }.to_json
end

get '/configure' do
  @settings = C3D::Settings.get_settings
  haml :configure
end

post '/configure' do
  request.body.rewind
  request_from_ui = JSON.parse request.body.read
  result = C3D::Settings.set_settings request_from_ui
  content_type :json
  response = { 'success' => result }.to_json
end

get '/set_doug' do
  content_type :json
  response = { 'success' => result, 'result' => $doug }.to_json
end

post '/set_doug' do
  request.body.rewind
  request_from_ui = JSON.parse request.body.read
  $doug = request_from_ui['doug']
  result = true
  content_type :json
  response = { 'success' => result, 'result' => $doug }.to_json
end
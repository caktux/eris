#!/usr/bin/env ruby
require File.join(File.dirname(__FILE__), 'eris_helpers.rb')

set :views, File.join(File.dirname(__FILE__), 'views')

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

get '/view' do
  swarum = get_dougs_storage 'swarum'
  redirect to("/view/#{swarum}")
end

get '/flaggedlist' do
  @moderate_this = 'flaggedlist'
  flaggedlist = get_dougs_storage 'flaggedlist'
  redirect to("/view/#{flaggedlist}")
end

get '/promotedlist' do
  @moderate_this = 'promotedlist'
  promotedlist = get_dougs_storage 'promotedlist'
  redirect to("/view/#{promotedlist}")
end

get '/blacklist' do
  @moderate_this = 'blacklist'
  blacklist = get_dougs_storage 'blacklist'
  redirect to("/view/#{blacklist}")
end

get '/issueslist' do
  #todo
end

get '/view/:contract' do
  @this_contract = params[:contract]
  @this_contract = address_guard @this_contract
  @contents = C3D::Assemble.new(@this_contract).content
  @lineage  = find_the_peak @this_contract
  @type     = contract_type @this_contract, @contents, @lineage
  haml :display_tree
end

post '/view/:contract/new_topic' do
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

post '/view/:contract/new_thread' do
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

post '/view/:contract/new_post' do
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

post '/view/:contract/upvote' do
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

post '/view/:contract/downvote' do
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
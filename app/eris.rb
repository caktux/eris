#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__), 'eris_helpers.rb')

set :views, File.join(File.dirname(__FILE__), 'views')

before do
  print "[ERIS::#{Time.now.strftime( "%F %T" )}] Params Recieved >>\t" + params.inspect + "\n"
  print "[ERIS::#{Time.now.strftime( "%F %T" )}] Request >>\t\t" + request.body.read + "\n"
end

get '/' do
  if $doug
    redirect to("/view")
  else
    p "There is NO DOUG. Please Add a DOUG in the My DAO Button."
    redirect to('/view/0x')
  end
end

get '/view' do
  if $doug
    swarum = get_dougs_storage 'swarum'
    redirect to("/view/#{swarum}")
  else
    p "There is NO DOUG. Please Add a DOUG in the My DAO Button."
    redirect to('/view/0x')
  end
end

get '/flaggedlist' do
  @moderate_this = 'flaggedlist'
  flaggedlist    = get_dougs_storage 'flaggedlist'
  redirect to("/view/#{flaggedlist}")
end

get '/promotedlist' do
  @moderate_this = 'promotedlist'
  promotedlist   = get_dougs_storage 'promotedlist'
  redirect to("/view/#{promotedlist}")
end

get '/issueslist' do
  #todo
end

get '/view/:contract' do
  @this_contract = params[:contract]
  @this_contract = address_guard @this_contract
  @contents      = C3D::Assemble.new(@this_contract).content
  @lineage       = find_the_peak @this_contract
  @type          = contract_type @this_contract, @contents, @lineage
  haml :display_tree
end

post '/view/:contract/new_topic' do
  topic = CreateTopic.new params[:content], get_dougs_storage('BLWCTopic'), params[:contract]
  if topic.topic_id != ('0x' || nil )
    result = true
  else
    result = false
  end
  redirect to("/view/#{params[:contract]}")
end

post '/view/:contract/new_thread' do
  thread = CreateThread.new params[:content], get_dougs_storage('BLWCThread'), params[:contract]
  if thread.thread_id != ('0x' || nil )
    result = true
  else
    result = false
  end
  redirect to("/view/#{params[:contract]}")
end

post '/view/:contract/new_post' do
  post = PostToThread.new params[:content], get_dougs_storage('BLWPostTT'), params[:contract]
  if post.post_id != ('0x' || nil )
    result = true
  else
    result = false
  end
  redirect to("/view/#{params[:contract]}")
end

post '/view/:contract/upvote' do
  post = VotePost.new params[:contract], 'upvote', get_dougs_storage('BLWVoteUpDown')
  if post.voted == true
    result = true
  else
    result = false
  end
  content_type :json
  redirect to("/view/#{params[:contract]}")
end

post '/view/:contract/downvote' do
  post = VotePost.new params[:contract], 'downvote', get_dougs_storage('BLWVoteUpDown')
  if post.voted == true
    result = true
  else
    result = false
  end
  content_type :json
  redirect to("/view/#{params[:contract]}")
end

post '/moderate/:contract/flag' do
  post = FlagPost.new params[:contract], get_dougs_storage('BLWFlagPost'), get_dougs_storage('flaggedlist')
  if post.added == true
    result = true
  else
    result = false
  end
  content_type :json
  redirect to("/flaggedlist")
end

post '/moderate/:contract/remove_flag' do
  post = RemoveFlag.new params[:contract], get_dougs_storage('BLWRemoveFlag'), get_dougs_storage('flaggedlist')
  if post.removed == true
    result = true
  else
    result = false
  end
  content_type :json
  redirect to("/flaggedlist")
end

post '/moderate/:contract/promote' do
  post = PromotePost.new params[:contract], get_dougs_storage('BLWPromotePost'), get_dougs_storage('promotedlist')
  if post.added == true
    result = true
  else
    result = false
  end
  content_type :json
  redirect to("/promotedlist")
end

post '/moderate/:contract/remove_promotion' do
  post = RemovePromoted.new params[:contract], get_dougs_storage('BLWRemovePromoted'), get_dougs_storage('promotedlist')
  if post.removed == true
    result = true
  else
    result = false
  end
  content_type :json
  redirect to("/promotedlist")
end

post '/moderate/:contract/blacklist' do
  post = BlacklistPost.new params[:contract], get_dougs_storage('BLWBlacklist'), get_dougs_storage('blacklist')
  if post.added == true
    result = true
  else
    result = false
  end
  content_type :json
  redirect to("/promotedlist")
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
  @settings = JSON.parse(File.read(File.join(ENV['HOME'], '.epm', 'c3d-config.json')))
  haml :configure
end

post '/configure' do
  update_settings params
  redirect to '/'
end

post '/set_doug' do
  $doug = params[:newDoug]
  redirect to '/'
end

post '/deployDoug' do
  EPM::Deploy.new(ERIS_REPO).deploy_package
  $doug = get_latest_doug
  redirect to '/'
end
require 'sinatra'
require 'sinatra/reloader'
require 'pg'
require 'pry-byebug'
require 'bcrypt'


require_relative 'lib/rps.rb'

configure do
  enable :sessions
  set :bind, '0.0.0.0'
end

helpers do
  def db
    db = RPS.create_db_connection('rps')
  end
end

before do
  if session[:user_id]
    @current_user = RPS::UsersRepo.find(db, session[:user_id])
  end
end

# homepage

get '/' do
  erb :index
end

# for welcome page - shows list of opponents to choose from.

get '/welcome' do
  opponents = RPS::UsersRepo.all db
  @opponents = opponents.select { |x| x['username'] != @current_user['username'] }
  active_rounds = RPS::RoundsRepo.all(db).select do |r|
    mine = r['p1'] == @current_user['id'] || r['p2'] == @current_user['id']
    active = r['p1move'].nil? || r['p2move'].nil?
    mine && active
  end

  @active_rounds = active_rounds.map do |round|
    opponent_id = if @current_user['id'] != round['p1']
      round['p1']
    else
      round['p2']
    end
    opponent = RPS::UsersRepo.find db, opponent_id
    {
      id: round['id'],
      opponent_name: opponent['username']
    }
  end

  erb :welcome, :locals => {
    opponent_list: erb(:opponent_list),
    active_games: erb(:active_games)
  }
end

get '/rounds/:id' do
  round = RPS::RoundsRepo.find db, {round_id: params[:id]}
  @round = round
  erb :new_game
end

post '/rounds/:id' do
  round = RPS::RoundsRepo.find db, {round_id: params[:id]}
  player = @current_user['id'] == round['p1'] ? 'p1' : 'p2'
  round[player+'move'] = params[:move]
  RPS::RoundsRepo.update db, round
  redirect to '/welcome'
end

get '/signup' do
# TODO: render template with form for user to sign up

  #erb :'auth/signup'
  erb :index
end

post '/signup' do
  #
  # SignUp Endpoint
  #
  # assume incoming parameters:
  # ex. /signin?username=someUser&password=somePassword
  #

  user_data = {:username => params[:username], :password => params[:password]}
  @user_save = RPS::UsersRepo.save(db, params)
  session['user_id'] = @user_save['id']   #user id (int)

  redirect to '/welcome'
end

post '/signin' do
  #
  # SignIn Endpoint
  #
  # assume incoming parameters:
  # ex. /signin?username=someUser&password=somePassword
  #

  user_data = {:username => params[:username], :password => params[:password]}
  @user_login = RPS::UsersRepo.user_login(db, user_data)

  if @user_login['id']
    session['user_id'] = @user_login['id']
    redirect to '/welcome'
  else
    "login error"
    end
end

get '/new_game' do
  erb :new_game
end


post '/rounds' do
  # this is where you create a new match between the current user and the user they clicke don
  # params will have key called :opponent_id
  # youll have to use the matchesrepo to record that a match has started with those two users
  # once thats done redirect to a match page
  user_data = {:p1 => @current_user['id'], :p2 => params[:opponent_id]}
  # round = RPS::RoundsRepo.save(@current_user['id'], params[:opponent_id])
  round = RPS::RoundsRepo.save(db, user_data)

  redirect to '/new_game'
  # redirect to /rounds/' + round['id']'
end

# get '/rounds/:id' do
  # this endpoint is where the users choose their and if both users have played a move
  # then the endpoint can show both moves and say who won.
# end

post '/playmove' do
  #
  # assume incoming /playmove?move=someMove&round_id=id
  #
  # get the round (game_id in the rounds table)
  round = RPS::RoundsRepo.find(params[:round_id])

  # is the @current_id['id'] player1 or player2?
  # we want to know given an id whether we will update
  # the p1move or p2move column
  if @current_user['id'] == round[:p1]
    player = "p1move"
  else
    player = "p2move"
  end

  # update the hash to so we know who made the move
  params[:player => player]

  # send the hash back to the db to be saved.
  # params we are sending back should have :round_id, :move, :player
  # note that :player will be the column name in the rounds table,
  # "p1move" or "p2move"
  RPS::RoundsRepo.play_move(params)

  redirect to '/summary'
end

# game summary
get '/summary' do
  erb :summary
end

# user sign out
post '/signout' do
  # if user id is not nil then remove id from session
  unless params[:id].nil?
    session.delete[params:id]
  end
  redirect to '/'
end

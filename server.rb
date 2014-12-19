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
  erb :welcome, :locals => {opponent_list: erb(:opponent_list)}
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
  
    if @user_login['id'] then
      session['user_id'] = @user_login['id']
      redirect to '/welcome'
    else
      "login error"
    end
end

post '/rounds' do
  # this is where you create a new match between the current user and the user they clicke don
  # params will have key called :opponent_id
  # youll have to use the matchesrepo to record that a match has started with those two users
  # once thats done redirect to a match page
  round = RPS::RoundsRepo.save(@current_user['id'], params[:opponent_id])
  redirect to '/rounds/' + round['id']
end

get '/rounds/:id' do
  # this endpoint is where the users choose their and if both users have played a move
  # then the endpoint can show both moves and say who won.
end


post '/rounds/rounds_id' do
 # play new game
 erb :welcome
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

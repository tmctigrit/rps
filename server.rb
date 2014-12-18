require 'sinatra'
require 'sinatra/reloader'
require 'pg'
require 'pry-byebug'


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

# homepage

get '/' do
  erb :index
end

# user signup

get '/signup' do
  erb :index
end

post '/signup' do
    @user_data = RPS::UsersRepo.save(db, params)
    session['user_id'] = @user_data['id']

    redirect to '/welcome'
end

# user signin

get '/signin' do
  erb :index
end

post '/signin' do
    # params = JSON.parse request.body.read
    
    # username = params['username']
    # password = params['password']
    
    @user_login = RPS::UsersRepo.find_by_username(db, params[:username])
    session['user_id'] = @user_login['id']

    redirect to '/welcome'
end

# welcome page; user after signin
get '/welcome' do
 erb :welcome
end

post '/welcome' do
 # play new game 
end

# new game page
get '/gamenew' do
    # choose opponent
 erb :new_game
end


# game over page
get '/gameover' do
  erb :game_over
end

# game summary
get '/summary' do
  erb :summary
end


# user sign out
post '/signout' do 
    session.clear
    redirect to '/'
end





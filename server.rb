require 'sinatra'
require 'sinatra/reloader'
require 'pg'
require 'pry-byebug'
require 'rack-flash'

require_relative 'lib/rps.rb'

configure do
  enable :sessions 
  set :bind, '0.0.0.0'
end 

helpers do 
    def db
        RPS.create_db_connection('rps')
    end
end

# homepage
get '/' do
  erb :index
end


get '/signup' do 

end

# user signup
post '/signup' do
  
end

# user signin
post '/signin' do
    params = JSON.parse request.body.read
    
    username = params['username']
    password = params['password']

    user = RPS::UsersRepo.find_by_username(username)
end

# welcome page; user after signin
get '/welcome' do

end

# new game page
get '/gamenew' do
 
 erb :new_game
end

# game over page
get '/gameover' do

end

# existing games
get '/gamesexisting' do

end

# game summary
get '/summary' do
  
end

post '/signout' do 
    session.clear
    redirect to '/'
end





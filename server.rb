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
      db = RPS.create_db_connection('rockpaperscissors')
    end
end

# homepage
get '/' do
  erb :index
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

    session['user_id'] = @user_save['id']

    redirect to '/welcome'
end

# user signin

get '/signin' do
  erb :index
end

post '/signin' do
    #
    # SignIn Endpoint
    #
    # assume incoming parameters:
    # ex. /signin?username=someUser&password=somePassword
    #

    # --- following commented code not needed, for now
    # params = JSON.parse request.body.read
    # ---
    
    user_data = {:username => params[:username], :password => params[:password]}
    @user_login = RPS::UsersRepo.user_login(db, user_data)
    if @user_login then
      session['user_id'] = username
      redirect to '/welcome'
    else
      status 400
    end
end


post '/rounds/rounds_id' do
 # play new game
 erb :welcome
end

# new game page
get '/game' do
    # choose opponent
 erb :new_game
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





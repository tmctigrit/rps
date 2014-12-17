require 'sinatra'
require 'sinatra/reloader'
require 'pg'
require 'pry-byebug'


require_relative 'lib/rps.rb'

set :bind, '0.0.0.0'

# homepage
get '/' do
  
end

# user signup
post '/signup' do

end

# user signin
post '/signin' do

end

# welcome page; user after signin
get '/welcome' do

end

# new game page
get '/gamenew' do

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






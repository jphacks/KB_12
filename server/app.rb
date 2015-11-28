require "sinatra"
require "sinatra/reloader" if development?
require 'active_record'
require 'json'
require 'mysql2'
#require 'omniauth-twitter'
#require 'twitter'

#mysql
ActiveRecord::Base.configurations = YAML.load_file('database.yml')
ActiveRecord::Base.establish_connection('development')

class User < ActiveRecord::Base
end

#Time out error
after do
  ActiveRecord::Base.connection.close
end

enable :sessions

before do
	unless session[:id].to_s.empty? then
		@id = session[:id]
	end
end

#########################################################################################

get '/' do
	"Hello World"
end


get '/home' do
	erb :home
end

get '/water/:id' do
	unless session[:id].to_s.empty? then
		erb :water	
	else
		erb :login
	end
end

get '/water/' do
	redirect :login
end

get '/register' do
	erb :register
end

post '/register' do
	user = User.new
	user.name = params[:name]
	user.email = params[:mail]
	user.password = params[:pass]
	user.save
	redirect '/home'
end

get '/login' do
	unless session[:id].to_s.empty? then
		redirect "water/" + session[:id].to_s
	else
		erb :login
	end
end

post '/login' do
	user = User.find_by_email(params[:mail])
	if params[:pass] == user.password then
		session[:id] = user.id
		redirect "water/" + user.id.to_s
	else
		redirect "login"
	end	
end

get '/logout' do
	unless session[:id].to_s.empty? then
		session.clear
	end
	redirect 'home'
end



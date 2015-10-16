require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/reloader'
require 'mysql'

set :database, "mysql://root@127.0.0.1:3306/FDUChat"

require_relative 'model/users'

get "/" do
  if (params[:u])
    Users.create(:username => params[:u], :password => params[:p])
  end
  users = Users.where(:username => 'test')
  users.first.password
end

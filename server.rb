require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/reloader'
require 'mysql'
require 'json'
require_relative 'error'
require_relative 'success'

set :bind, '0.0.0.0'
set :database, "mysql://root@127.0.0.1:3306/FDUChat"

require_relative 'model/users'

get "/" do
  if (params[:u])
    Users.create({:username => params[:u], :password => params[:p]})
  end
  users = Users.all
  res = []
  users.each do |u|
    res.push u.username
  end
  res.inspect
end

get "/request" do
  request.body
end

#login
post "/login" do
  begin
    req = JSON.parse(request.body.string)
  rescue
    return Error.json_fault
  end
  if (req.has_key? "username") and (req.has_key? "password")
    user = Users.where(:username => req["username"])
    if user.size == 0
      return Error::UserOPs.no_user
    else
      passwd = user.first.password
      if req["password"] == passwd
        return Success::UserOPs.login_success
      else
        return Error::UserOPs.error_passwd
      end
    end
  end
end

get "/users/:username" do
  if Users.where(:username => params[:username]).size == 1
    return Error::UserOPs.user_exists
  end
end

#register
post "/users/:username" do
  begin
    req = JSON.parse(request.body.string)
  rescue
    return Error.json_fault
  end
  if (req.has_key? "password") and req["password"] != ""
    if Users.where(:username => params[:username]).size == 1
      return Error::UserOPs.user_exists
    else
      Users.new do |u|
        u.username = req["username"]
        u.password = req["password"]
        u.save
      end
    end
  else
    return Error::UserOPs.passwd_missed
  end
  Success::UserOPs.register_success
end

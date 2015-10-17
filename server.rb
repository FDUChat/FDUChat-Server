require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/reloader'
require 'mysql'
require 'json'
require 'jpush'
require_relative 'error'
require_relative 'success'
require_relative 'config'

set :bind, '0.0.0.0'
set :database, "mysql://root@127.0.0.1:3306/FDUChat"

require_relative 'model/users'
require_relative 'model/contacts'

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
    return 1
  else
    return 0
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

#get contact info
get "/users/:username/contacts" do
  user = Users.where(:username => params[:username])
  if user.size == 0
    return Error::UserOPs.no_user
  else
    user = user.first
    if not user.contactid?
      cts = Contacts.new do |c|
        c.contacts = JSON.generate({"contacts"=>""})
        c.save
      end
      user.contactid = cts.id
    else
      cts = Contacts.find(user.contactid)
    end
  end
  cts.contacts
end

#add contact
post "/users/:username/contacts" do
  user = Users.where(:username => params[:username])
  if user.size == 0
    return Error::UserOPs.no_user
  else
    user = user.first
    if not user.contactid?
      cts = Contacts.new do |c|
        c.contacts = request.body.string
        c.save
      end
      user.contactid = cts.id
    else
      cts = Contacts.find(user.contactid)
      cts.contacts = request.body.string
    end
  end
  Success::UserOPs.update_contacts_success
end

#send message
post "/message/send" do
  client = JPush::JPushClient.new($AppKey, $MasterSecret)
  begin
    data = JSON.parse(request.body.string)
  rescue
    return Error.json_fault
  end
  payload = JPush::PushPayload.build(
    platform: JPush::Platform.all,
    message: JPush::Message.build(
      msg_content: data["message"],
      extras: {
        "sender" => data["sender"]
      }
    ),
    audience: JPush::Audience.build(
      _alias: data["alias"]
    )
  )
  res = client.sendPush(payload)
  res.toJSON
end

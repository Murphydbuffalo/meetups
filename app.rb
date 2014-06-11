require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'omniauth-github'

require_relative 'config/application'

Dir['app/**/*.rb'].each { |file| require_relative file }
# ** -> recursive?  requires all models and views

helpers do
  def current_user
    user_id = session[:user_id]
    @current_user ||= User.find(user_id) if user_id.present?
  end

  def signed_in?
    current_user.present?
  end
end

def set_current_user(user)
  session[:user_id] = user.id
end

def authenticate!
  unless signed_in?
    flash[:notice] = 'You need to sign in if you want to do that!'
    #flash gets passed to templates, similar to session...global
    redirect '/'
  end
end

get '/' do
  @meetups = Meetup.all

  erb :index
end

get '/auth/github/callback' do
  auth = env['omniauth.auth']

  user = User.find_or_create_from_omniauth(auth)
  set_current_user(user)
  flash[:notice] = "You're now signed in as #{user.username}!"

  redirect '/'
end

get '/sign_out' do
  session[:user_id] = nil
  flash[:notice] = "You have been signed out."

  redirect '/'
end

get '/meetups/:meetup_id' do
  @meetup = Meetup.where(id: params[:meetup_id]).first

  erb :show
end

post '/' do
  authenticate!
end

get '/create' do
  authenticate!
  erb :create_meetup
end

post '/create' do
  meetup = Meetup.create(
    name: params[:name],
    location: params[:location],
    date: params[:date],
    description: params[:description]
    )

  participant = Participation.create(
    user_id: session[:user_id], 
    meetup_id: params[:meetup_id],
    organizer?: true
    )

  redirect "/meetups/#{meetup.id}"
end

post '/meetups/:meetup_id/join' do
  authenticate!

  participant = Participation.create(
    user_id: session[:user_id], 
    meetup_id: params[:meetup_id]
    )

  redirect "/meetups/#{params[:meetup_id]}"
end

post '/meetups/:meetup_id/leave' do
  authenticate!
  Participation.where(
    user_id: session[:user_id],
    meetup_id: params[:meetup_id]
    ).first.destroy

  redirect '/'
end

post '/meetups/:meetup_id/comments' do
  authenticate!
  Comment.create(
    user_id: session[:user_id], 
    meetup_id: params[:meetup_id],
    body: params[:body]
    )
  redirect "/meetups/#{params[:meetup_id]}"
end

require 'rubygems'
require 'vendor/sinatra/lib/sinatra'
require 'db/load'

before do
  if params[:email]
    @email = Email.find_by_name(params[:email])
    @email_exists = true if @email
    @email ||= Email.create(:name => params[:email])
  end
end

get '/' do
  haml :index, :layout => :default
end

get '/:email' do
  # find and display location
end

post '/' do
  if !@email
    # handle missing email
    erb :missing_email, :layout => :default
  elsif @email_exists && params[:token].to_s =~ /^\s*$/
    # handle missing token
    haml :missing_token, :layout => :default
  elsif @email.token =~ params[:token]
    # handle incorrect token
    haml :incorrect_token, :layout => :default
  elsif params[:location].to_s =~ /^\s*$/
    # handle missing location
    haml :missing_location, :layout => :default
  else
    # things worked out correctly
    @email.locate!(params[:location])
    haml :updated, :layout => :default
  end
end

put '/' do
end

get '/request_reset/:email' do
  # send an email to allow resetting this email's token
end

get '/reset/:email/:reset_token' do
  # reset the token for this email address
end


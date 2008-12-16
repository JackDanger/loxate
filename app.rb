require 'rubygems'
require 'vendor/sinatra/lib/sinatra'
require 'datastore'

get '/' do
  haml :index, :layout => :default
  # introduction and forms for creating/updating
end

get '/:email' do
  # find and display location
end

post '/' do
  # save the location if the email is now
  # otherwise display error and ask for token
end

put '/' do
  # update the location if the token is valid
end

get '/request_reset/:email' do
  # send an email to allow resetting this email's token
end

get '/reset/:email/:reset_token' do
  # reset the token for this email address
end

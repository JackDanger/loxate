require 'rubygems'
require 'vendor/sinatra/lib/sinatra'
require 'db/load'

get '/' do
  haml :index, :layout => :default
  # introduction and forms for creating/updating
end

get '/:email' do
  find_email
  # find and display location
end

post '/' do
  find_email
  # save the location if the email is now
  # otherwise display error and ask for token
end

put '/' do
  find_email
end

get '/request_reset/:email' do
  find_email
  # send an email to allow resetting this email's token
end

get '/reset/:email/:reset_token' do
  find_email
  # reset the token for this email address
end

helpers do
  
  def find_email
    @email = Email.find_or_create_by_name(params[:email])
  end

end
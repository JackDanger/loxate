require 'rubygems'
require 'vendor/sinatra/lib/sinatra'
require 'db/load'


helpers do

  def find_email
  email = params[:email]
  email ||= params[:splat].first if params[:splat] && params[:splat].first =~ /.+@.+/
  
  if email
    @email = Email.find_by_name(email)
    @email_exists = true if @email
    @email ||= Email.create(:name => email)
  end
  end

  def update_email
    if !@email
      # handle missing email
      erb :missing_email, :layout => :default
    elsif @email_exists && params[:token].to_s =~ /^\s*$/
      # handle missing token
      haml :missing_token, :layout => :default
    elsif @email.token == params[:token]
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
end

get '/' do
  find_email
  haml :index, :layout => :default
end

# posting and putting will trigger the same update operaion
post '/' do
  find_email
  update_email
end

put '/' do
  find_email
  update_email
end

get '/request_reset/*' do
  find_email
  # send an email to allow resetting this email's token
  @email.send_reset_email
end

get '/reset/:email/:reset_token' do
  find_email
  # reset the token for this email address
end

get '/*' do
  find_email
  if @email.location
    @email.location.coordinates
  else
    stop [404, "That email is not tracked at Loxate"]
  end
end

not_found do
  haml :index, :layout => :default
end
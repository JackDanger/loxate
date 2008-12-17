require     'rubygems'
require     'activesupport'
require     File.join(File.dirname(__FILE__), 'vendor/sinatra/lib/sinatra')
require     File.join(File.dirname(__FILE__), 'vendor/sinatra/lib/sinatra/test/unit') if 'test' == ENV['environment']
require     File.join(File.dirname(__FILE__), 'db/load')
set :views, File.join(File.dirname(__FILE__), 'views')


helpers do

  def find_email
    email = params[:email]
    email ||= params[:splat].first if params[:splat] && params[:splat].first =~ /.+@.+/
  
    if email
      @email = Email.find_or_create_by_name(email)
      # give 'em just a few minutes to play
      @token_required = true if @email.created_at < (Time.new - 60*30)
    end
    @email
  end

  def update_email
    if !@email
      # handle missing email
      erb :missing_email, :layout => :default
    elsif @token_required && params[:token].blank?
      # handle missing token
      haml :missing_token, :layout => :default
    elsif @token_required && @email.token != params[:token]
      # handle incorrect token
      haml :incorrect_token, :layout => :default
    elsif params[:location].blank?
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
  # send an email to allow resetting this email's token
  find_email && @email.send_reset_email
  haml :email_sent, :layout => :default
end

get '/reset/*/*' do
  if find_email && @email.reset_token == params[:splat].last
    haml :show_token, :layout => :default
  else
    erb "<h2>Whoops!</h2>That was a bad link.  If you go to the <a href='/'>home page</a> you can get a fresh link by asking for a token reset."
  end
end

get '/*.js' do
  # TODO json content-type
  if find_email && location = @email.location
    %W({"address": "#{location.address}", "latitude": "#{location.latitude}", "longitude": "#{location.longitude}"})
  else
    stop [404, %W({"status": 404, "message": "#{@email.name} is not tracked by Loxate"})]
  end
end

get '/*.txt' do
  # TODO find geo content-type (?) or use plain text
  if find_email && @email.location
    @email.location.coordinates
  else
    stop [404, "That email is not tracked at Loxate"]
  end
end

get '/*' do
  if find_email && @email.location
    haml :updated, :layout => :default
  else
    stop [404, [:haml, :missing_email, {:layout => :default}]]
  end
end

not_found do
  haml :index, :layout => :default
end
require 'rubygems'
gem 'guid'
require 'guid'
require 'net/smtp'

class Email < ActiveRecord::Base

  # :name, :token, :reset_token

  ADDRESS_FORMAT = /^[a-z0-9!#\$%&'\*\+\-\/=\?\^_`{}|~]+(\.[a-zA-Z0-9!#\$%&'\*\+\-\/=\?\^_`{}|~]+)*@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i

  validates_presence_of     :address, :message => "Please enter an email address"
  validates_uniqueness_of   :address, :message => 'That email address is already being used'
  validates_format_of       :address, :message => 'Please enter a valid email address', :with => ADDRESS_FORMAT

  def reset!
    self.reset_token = Guid.new.to_s
    self.token       = Guid.new.to_s.split('-').first
    save
  end

  def send_reset_email
  	Net::SMTP.start('smtp.gmail.com', 465, 'mail.loxate.com') do |smtp|
      message = <<-END_OF_MESSAGE
From: Loxate.com <email@loxate.com>
To: #{name} <#{name}>
Subject: Resetting your Loxate.com access token

Hey there, sorry to hear that you're having trouble using the site.

Click this link to get a new "token" that makes sure you're you when
you use loxate.com:

http://loxate.com/reset/#{name}/#{reset_token}

Feel free to reply to this message.

END_OF_MESSAGE
  		smtp.send_message message, 'email@loxate.com', name, ENV['email_username'], ENV['email_password']
  	end
  end

end

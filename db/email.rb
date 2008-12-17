require 'rubygems'
gem 'guid'
require 'guid'
require 'net/smtp'
require File.join(File.dirname(__FILE__), 'smtp_tls')

class Email < ActiveRecord::Base

  # :name, :token, :reset_token

  ADDRESS_FORMAT = /^[a-z0-9!#\$%&'\*\+\-\/=\?\^_`{}|~]+(\.[a-zA-Z0-9!#\$%&'\*\+\-\/=\?\^_`{}|~]+)*@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i

  validates_presence_of     :name, :message => "Please enter your email address"
  validates_uniqueness_of   :name, :message => 'That email address is already being used'
  validates_format_of       :name, :message => 'Please enter your real email address', :with => ADDRESS_FORMAT

  attr_readonly :name

  has_many :locations, :include => :visits, :order => "visits.created_at DESC"
  has_one  :location,  :include => :visits, :order => "visits.created_at DESC"

  before_create :update_tokens

  def locate!(address)
    locations.find_or_create_by_user_entered_location(address)
  end

  def reset!
    update_tokens
    save
  end

  def update_tokens
    self.reset_token = Guid.new.to_s
    self.token       = Guid.new.to_s.split('-').first
  end

  def send_reset_email
  	Net::SMTP.start('smtp.gmail.com', 587, 'mail.loxate.com', ENV['EMAIL_USERNAME'], ENV['EMAIL_PASSWORD'], 'plain') do |smtp|
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
  		smtp.send_message message, 'email@loxate.com', name
  	end
  end

end

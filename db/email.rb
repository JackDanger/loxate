gem 'guid'
require 'guid'

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
end

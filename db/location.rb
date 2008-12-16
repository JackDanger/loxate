class Location < ActiveRecord::Base

  # :nickname, :address, :coordinates

  validates_presence_of :coordinates

  has_many :visits

end
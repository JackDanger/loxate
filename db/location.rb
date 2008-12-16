require 'open-uri'

class Location < ActiveRecord::Base

  # :nickname, :address, :coordinates

  GOOGLE_MAP_KEY = ENV['google_key'] || "ABQIAAAAfuwksR5DY21zFbPBhashcRSIOFcUe7xWTqvkPP1wySqBHxG2ZRTA5vp0mc_tHzEF3JboST57MQ_Ivg"

  validates_presence_of :coordinates

  has_many :visits

  def visited!
    visits.create
  end

  def self.get_coordinates(location)
    csv = open("maps.google.com/maps/geo?q=#{location}&output=csv&sensor=false&key=#{GOOGLE_MAP_KEY}").read
    status, accuracy, c1, c2 = csv.to_s.split(',')
    "#{c1},#{c2}"
  end

end
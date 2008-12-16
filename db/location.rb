require 'open-uri'

class Location < ActiveRecord::Base

  # :nickname, :address, :coordinates

  GOOGLE_MAP_KEY = ENV['google_key'] || "ABQIAAAAfuwksR5DY21zFbPBhashcRSIOFcUe7xWTqvkPP1wySqBHxG2ZRTA5vp0mc_tHzEF3JboST57MQ_Ivg"

  validates_presence_of :coordinates

  has_many :visits

  def visited!
    visits.create
  end

  class << self

    def parse(location)
      location = location.to_s
      nickname, address, coordinates = '', '', ''

      return '', '', '' if location =~ /^\s*$/

      # if there is a nickname entered to name this location then extract it
      if location =~ /(.*)\[(.*)\]$/
        location, nickname = location.scan(/(.*)\[(.*)\]$/).flatten
      end

      # if the user has passed us some coordinates then accept them as given
      # otherwise look them up
      coordinates = location.=~(/^\s*-?\d+\.\d+,-?\d+\.\d+\s*$/) ?
        location : geocoordinate(location)

      [nickname, address, coordinates]
    end

    def geocoordinate(location)
      csv = open("maps.google.com/maps/geo?q=#{location}&output=csv&sensor=false&key=#{GOOGLE_MAP_KEY}").read
      status, accuracy, c1, c2 = csv.to_s.split(',')
      "#{c1},#{c2}"
    end

  end

end
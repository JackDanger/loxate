require 'open-uri'

class Location < ActiveRecord::Base

  # :nickname, :address, :coordinates

  GOOGLE_MAP_KEY = ENV['google_key'] || "ABQIAAAAfuwksR5DY21zFbPBhashcRSIOFcUe7xWTqvkPP1wySqBHxG2ZRTA5vp0mc_tHzEF3JboST57MQ_Ivg"

  validates_presence_of :coordinates

  belongs_to :email
  has_many :visits

  def visited!
    visits.create
  end

  class << self

    def find_or_create_by_user_entered_location(location)

      nickname, address, coordinates = parse(location)

      if !nickname.empty?
        # see if this address is really just a nickname
        if current_location = find(:first, :conditions => ["LOWER(locations.nickname) = ?", address.downcase])
          address     = current_location.address
          coordinates = current_location.coordinates
        end
      elsif !address.empty?
        # see if this address has already been used
        find(:first, :conditions => ["LOWER(locations.address) = ?", address.downcase])
      end

      # lookup coordinates unless they've been provided
      coordinates = geocoordinate(address) if coordinates.empty?

      # if a nickname has been provided then make sure
      # it doesn't get stuck with an old address
      if current_location && !nickname.empty?
        current_location.address = address
        current_location.coordinates = coordinates
      end

      current_location ||= new(:coordinates => coordinates,
                               :address => address,
                               :nickname => nickname)
      current_location.save
      current_location
    end

    def parse(location)
      nickname, address, coordinates = '', location.to_s, ''

      return '', '', '' if address =~ /^\s*$/

      # if there is a nickname entered to name this address then extract it
      if address =~ /(.*)\[(.*)\]$/
        address, nickname = address.scan(/(.*)\[(.*)\]$/).flatten
      end

      # if the user has passed us some coordinates then accept them as given
      coordinates = address if address =~ /^\s*-?\d+\.\d+,-?\d+\.\d+\s*$/

      [nickname.strip, address.strip, coordinates.strip]
    end

    def geocoordinate(location)
      csv = open("http://maps.google.com/maps/geo?q=#{URI.escape(location)}&output=csv&sensor=false&key=#{GOOGLE_MAP_KEY}").read
      status, accuracy, c1, c2 = csv.to_s.split(',')
      "#{c1},#{c2}"
    end

  end

end
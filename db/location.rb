require 'open-uri'

class Location < ActiveRecord::Base

  # :nickname, :address, :coordinates

  GOOGLE_MAP_KEY = ENV['google_key'] || "ABQIAAAAfuwksR5DY21zFbPBhashcRSIOFcUe7xWTqvkPP1wySqBHxG2ZRTA5vp0mc_tHzEF3JboST57MQ_Ivg"

  validates_presence_of :coordinates
  validates_exclusion_of :coordinates, :in => ["0,0"], :message => "Even Google couldn't figure out where that was"

  belongs_to :email
  has_many :visits
  
  after_save proc {|location| location.visits.create }

  def latitude;  coordinates.split(',').first; end
  def longitude; coordinates.split(',').last; end

  class << self

    def find_or_create_by_user_entered_location(location)

      nickname, address, coordinates = parse(location)

      if !address.blank?
        # see if this address is really just a nickname
        if current_location = find(:first, :conditions => ["LOWER(locations.nickname) = ?", address.downcase])
          # use the existing address and coords saved previously
          address     = current_location.address
          coordinates = current_location.coordinates
        end
        # see if this address has already been used
        current_location ||= find(:first, :conditions => ["LOWER(locations.address) = ?", address.downcase])
      end

      # lookup coordinates unless they've been provided
      coordinates = geocoordinate(address) if coordinates.blank?

      # if a save nickname has been provided to an existing location
      # then make sure the pieces get connected
      if current_location && !nickname.blank?
        current_location.nickname    = nickname
        current_location.address     = address
        current_location.coordinates = coordinates
      end

      # create a new record if we haven't found one yet
      current_location ||= new(:coordinates => coordinates,
                               :address => address,
                               :nickname => nickname)

      # save it just once - this marks right now as a 'visit'
      current_location.save
      current_location
    end

    def parse(location)
      nickname, address, coordinates = nil, location, nil

      return nil, nil, nil if address.blank?

      # if there is a nickname entered to name this address then extract it
      if address =~ /(.*)\[(.*)\]$/
        address, nickname = address.scan(/(.*)\[(.*)\]$/).flatten
        address.strip!
        nickname.strip!
      end

      # if the user has passed us some coordinates then accept them as given
      coordinates = address if address =~ /^\s*-?\d+\.\d+,-?\d+\.\d+\s*$/

      [nickname, address, coordinates]
    end

    def geocoordinate(location)
      csv = open("http://maps.google.com/maps/geo?q=#{URI.escape(location)}&output=csv&sensor=false&key=#{GOOGLE_MAP_KEY}").read
      status, accuracy, c1, c2 = csv.to_s.split(',')
      "#{c1},#{c2}"
    end

  end

end
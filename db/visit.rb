class Visit < ActiveRecord::Base

  belongs_to :location

  validates_presence_of :location

end
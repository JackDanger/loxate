require 'rubygems'
require 'active_record'

ENV['RACK_ENV'] ||= 'production'

root = File.expand_path(File.dirname(__FILE__))
dbfile = File.join(root, "data.#{ENV['RACK_ENV']}.sqlite")

ActiveRecord::Base.logger = Logger.new(File.join(root, "log.#{ENV['RACK_ENV']}.log"))
ActiveRecord::Base.colorize_logging = false

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :dbfile  => dbfile
)

unless File.exist?(dbfile)
  ActiveRecord::Schema.define do
    create_table :emails do |table|
      table.column :name, :string
      table.column :token, :string
      table.column :reset_token, :string
      table.column :created_at, :datetime
      table.column :updated_at, :datetime
    end

    create_table :locations do |table|
      table.column :email_id, :integer
      table.column :nickname, :string
      table.column :address, :string
      table.column :coordinates, :string
      table.column :created_at, :datetime
      table.column :updated_at, :datetime
    end

    create_table :visits do |table|
      table.column :location_id, :integer
      table.column :created_at, :datetime
    end
  end
end

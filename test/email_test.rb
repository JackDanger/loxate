require File.join(File.dirname(__FILE__), 'test_helper')

class EmailTest < Test::Unit::TestCase

  def setup
    Email.create :name => "first@email.com"
  end

  should_have_many :locations
  should_have_one  :location

  should_require_attributes        :name, :message => /Please enter your email address/
  should_require_unique_attributes :name, :message => /That email address is already being used/
  should_have_readonly_attributes  :name
  should_not_allow_values_for :name, 'what', 'empty@', 'domain.com', '@something.com', 'wow... what@email.com', :message => /Please enter your real email address/
  should_allow_values_for     :name, 'email@example.com', 'complex+name_code-list@uk.gov.att-company.co.au'
end

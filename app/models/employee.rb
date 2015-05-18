class Employee < ActiveRecord::Base
  # Remember to create a migration!
  attr_accessor :preferred_days,  :roles, :day_availabilities,  :night_availabilities

  after_initialize :add_variables

  def add_variables
  	@preferred_days
  	@roles
  	@day_availabilities
  	@night_availabilities

  end
end




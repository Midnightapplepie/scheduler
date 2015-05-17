class Employee < ActiveRecord::Base
  # Remember to create a migration!
  serialize :preferred_days, :roles, :day_availibilites, :night_availabilites
end




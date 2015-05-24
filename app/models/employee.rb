class Employee < ActiveRecord::Base
  # Remember to create a migration!

  def preferred_days
  	self.preferred_days_text.split(",").map(&:to_i)
  end

  def roles
  	r = {}
  	data = self.roles_text.split(",")
  	r[:primary] = data.first
  	r[:secondary] = data.last
  	r
  end

  def morning_avail
  	self.morning_avail_text.split(",").map(&:to_i)
  end

  def night_avail
  	self.night_avail_text.split(",").map(&:to_i)
  end

  def days_assigned
  	self.days_assigned_text.split(",").map(&:to_i)
  end

  def remaining_min_days
  	self.minimum_days_required - days_assigned.count
  end

  def flex_score
  	minimum_days_required.to_f / night_avail.count
  end
end




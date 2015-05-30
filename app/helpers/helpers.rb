def prepare_for_view(optimal_schedules,working_staffs,backup_staffs)
	weeks = []
	optimal_schedules.each do |week|
		ar = []
		week.each_with_index do |employees, index|
			day = Weekday.new(index+1,working_staffs)
			# puts day.night_avail
			day.assign_night(employees)
			day.assign_morning(employees)
			backup_staffs.each do |staff|
				day.night_avail.push(staff) if staff.night_avail.include?(day.int)
			end
			ar << day
		end
		weeks << ar
	end
	weeks
end

def organize_data(params)
	#used by routes to organize params from forms
	hash ={}
	data = %w[first_name last_name minimum_days_required phone_number full_time days_assigned_text morning_avail_text night_avail_text roles_text preferred_days_text]
	data.each do |key|
		hash[key.to_sym] = params[key]
	end
	hash
end
def display_sched(array)
	week = {}
	days = %w(Monday Tuesday Wednesday Thursday Friday Saturday Sunday)
	array.each_with_index do |day, index| 
		week[days[index]] = day
	end
	return week

end

def assign_role(day_array)
	#day - role, assign person to role
	#1 host
	#2 kitchen
	#3 delivery
	hash = {}
	roles = ["host","kitchen","delivery","buser"]
	day_array.each do |employee|
		prim_role = employee.roles[:primary]
		sec_role = employee.roles[:secondary]
		if hash[prim_role]
			if hash[sec_role]
				r = roles.sample
				hash[r] = employee
				roles.delete(r)
			else
				hash[sec_role] = employee	
				roles.delete(sec_role)
			end
		else
			hash[prim_role] = employee
			roles.delete(prim_role)
		end
	end
	hash
end
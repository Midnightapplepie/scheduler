class Weekday

	attr_accessor :morning_avail, :night_avail, :morning_roles_needed,
				  :night_roles_needed, :morning_shift, :night_shift
	attr_reader :day, :int

	def initialize(n,all_staffs)
		days={1 => "Monday",
			  2 => "Tuesday",
			  3 => "Wedensday",
			  4 => "Thursday",
			  5 => "Friday",
			  6 => "Saturday",
			  7 => "Sunday"}

		@day = days[n]
		@int = n


		@morning_avail = []
		@morning_shift = {}
			
		@night_avail = []
		@night_shift = {}
		if [1,7].include?(int)
			@morning_roles_needed = []
		else
			@morning_roles_needed = ["host","kitchen"]
		end
		@night_roles_needed = ["host","kitchen","buser","delivery"]
		plot_day(all_staffs)
	end

	def plot_day(all_staffs)
		self.night_avail = all_staffs.select{|e| e.night_avail.include?(self.int)}
		if ![1,7].include?(self.int)
			self.morning_avail = all_staffs.select{|e| e.morning_avail.include?(self.int)}
		end
	end

	def assign_by_roles(employees_ar,roles_ar)
		hash = {}
		roles = roles_ar
		staffs = employees_ar
		employees_ar.each do |employee|
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

	def assign_morning(employees_ar)
		staffs = employees_ar.select{|e| e.morning_avail.include?(self.int)}
		roles = self.morning_roles_needed
		
		if ![1,7].include?(self.int)
			self.morning_shift = assign_by_roles(staffs,roles)
			self.morning_avail -= self.morning_shift.values
		end
	end	


	def assign_night(employees_ar) 
		roles = self.night_roles_needed
		self.night_avail-= employees_ar
		self.night_shift = assign_by_roles(employees_ar,roles)
	end


end

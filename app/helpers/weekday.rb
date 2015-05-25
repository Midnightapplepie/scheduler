class Weekday

	attr_accessor :morning_avail, :night_avail, :morning_roles_needed,
				  :night_roles_needed, :morning_shift, :night_shift
	attr_reader :day, :int

	def initialize(n)
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
		@morning_shift = []
			
		@night_avail = []
		@night_shift = []
		if [1,7].include?(int)
			@morning_roles_needed = []
		else
			@morning_roles_needed = ["host","kitchen"]
		end
		@night_roles_needed = ["host","kitchen","buser","delivery"]
	end

	def count_morning_avail_with(role)
		morning_avail.count{|employee| employee.roles[:primary] == role}
	end	

	def count_night_avail_with(role)
		night_avail.count{|employee| employee.roles[:primary] == role}
	end

	def acceptable
		roles_exist = []
		night_shift.each{|e| roles_exist<< e.roles[:primary]}
	end
end

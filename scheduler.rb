require './config/environment'
require './weekday.rb'

staffs = Employee.all
staffs.each do |e|
	e.update(days_assigned_text: "")
end

=begin 	
normal = 4 people working, 1 host, 1 buser, 1 deliery, 1 kitchen #jeff is here
full_time employee, get priority

base on minimum_days_required, and current opening and roles, assign

1. find all days where morning staffs avail <= 2
2. find all days where night staffs avail <= 4
3. schedule them first
4. find all employees where required days <= 2 && not fully assigned, assign them first
5. prioritize 5,6,7 and than iterate through each day to schedule people

how to make decision to assign a staff
1. select primary fits, sort by count of other best fit options, take first
2. select 

=end
class Schedule
	attr_accessor :priorities, :schedule
	attr_reader :staffs, :default_needs

	def initialize(staffs)
		@staffs = staffs
		# @days_unassigned = [1,2,3,4,5,6,7]
		@schedule = new_schedule
		plot_staffs
	end

	def new_schedule
		[1,2,3,4,5,6,7].map{|i| Weekday.new(i)}
	end

	def plot_staffs
		schedule.each do |day|
			day.night_avail = staffs.select{|e| e.night_avail.include?(day.int)}
			if !morning_closed?(day.int)
				day.morning_avail = staffs.select{|e| e.morning_avail.include?(day.int)}
			end
		end
	end

	def morning_closed?(n)
		return true if [1,7].include?(n)
	end

	def bottle_necks
		#days with no choices
		prioritize = []
		prioritize += schedule.select do |day| 
			(!morning_closed?(day) && day.morning_avail.count <= 2) or day.night_avail.count <= 4  
		end
		prioritize
	end

	def assign(day,employee)
		day.night_shift += [employee]
		day.night_avail -= [employee]
		if day.night_roles_needed.include?(employee.roles[:primary])
			day.night_roles_needed -= [employee.roles[:primary]]
		else
			day.night_roles_needed -= [employee.roles[:secondary]]
		end

		if !morning_closed?(day.int) && employee.morning_avail.include?(day.int) && day.morning_shift.count < 2
			day.morning_shift += [employee]
			day.morning_avail -= [employee]
			if day.morning_roles_needed.include?(employee.roles[:primary])
				day.morning_roles_needed -= [employee.roles[:primary]]
			else
				day.morning_roles_needed -= [employee.roles[:secondary]]
			end
		end
		employee.update(days_assigned_text: (employee.days_assigned << day.int).join(",")) 
	end

	def assign_bottle_necks
		days = bottle_necks
		days.each do |day| 
			if day.morning_avail.count <= 2
				day.morning_avail.each{|e| assign(day,e)}
			elsif day.night_avail.count <= 4
				day.morning_avail.each{|e| assign(day,e)}
			end
		end
	end	

	def assign_employees_with_2_days_or_less
		staffs_array = staffs.select{|e| e.minimum_days_required <= 2 && e.minimum_days_required-e.days_assigned.count > 0}
		staffs_array.sort_by!{|e| e.night_avail.count}
		staffs_array.each do |e| 
			while e.minimum_days_required > e.days_assigned.count && optimal_day(e,e.roles[:primary])
				assign(optimal_day(e,e.roles[:primary]),e)
			end
		end
	end 

	def fill_morning_by(day,role, prim_or_sec_sym)
		selected = day.morning_avail.select{|e| e.roles[prim_or_sec_sym] == role && e.days_assigned.count < e.minimum_days_required}
		if selected.count == 1
			assign(day,selected.first)
		elsif selected.count > 1
			other_days_avail = schedule.count{|day| day.morning_roles_needed.include?(role)}
			selected.sort_by{|e| e.remaining_min_days - other_days_avail}
			assign(day,selected.first)
		end
	end

	def fill_night_by(day,role, prim_or_sec_sym) 
		selected = day.night_avail.select{|e| e.roles[prim_or_sec_sym] == role && e.days_assigned.count < e.minimum_days_required}

		if selected.count == 1
			assign(day,selected.first)
		elsif selected.count > 1
			other_days_avail = schedule.count{|day| day.night_roles_needed.include?(role)}
			selected.sort_by{|e| e.remaining_min_days - other_days_avail}
			assign(day,selected.first)
		end
	end

	def fill_day(day)
		needs = day.morning_roles_needed
		needs.each do |role|
			fill_morning_by(day,role,:primary)
		end
		if !(day.morning_roles_needed==[])
			needs.each{|role| fill_morning_by(day,role,:secondary)}
		end
	end

	def fill_night(day)
		needs = day.night_roles_needed
		needs.each do |role| 
			fill_night_by(day,role,:primary)
		end
		if !(day.night_roles_needed == [])
			needs.each{|role| 	fill_night_by(day,role,:secondary)}
		end
	end
			
	def assign_staffs
		assign_bottle_necks
		assign_employees_with_2_days_or_less

		schedule.rotate!(4) # prioritize 5,6,7
		schedule.each do |day|
			fill_day(day)
		end
		schedule.each do |day|
			fill_night(day)
		end
	end

	def optimal_day(employee, role)
		primary = role
		# return days where employee's primary roles is needed and that employee is avaliable
		nights = schedule.select do |day| 
			day.night_roles_needed.include?(primary) && employee.night_avail.include?(day.int) && !employee.days_assigned.include?(day.int)
		end
		nights.sort!{|a,b| b.int<=>a.int} # prioritize end of week
		mornings  = schedule.select do |day|
			day.morning_roles_needed.include?(primary) && employee.morning_avail.include?(day.int) && !employee.days_assigned.include?(day.int)
		end
		mornings.sort!{|a,b| b.int<=>a.int} # prioritize end of week
		case
		when !nights.empty? && !mornings.empty?

			night = nights.min_by{|day| day.count_night_avail_with(primary)}
			morning = mornings.min_by{|day| day.count_morning_avail_with(primary)}

			if morning.count_morning_avail_with(primary) <= night.count_night_avail_with(primary)
				return morning
			else
				return night
			end

		when nights.empty? && mornings.empty?
			return false if primary == employee.roles[:secondary]
			return optimal_day(employee,employee[:secondary]) 
		when nights.empty?
			return mornings.min_by{|day| day.count_morning_avail_with(primary)}
		when mornings.empty?
			return nights.min_by{|day| day.count_night_avail_with(primary)}
		end
	end
end

week = Schedule.new(staffs)
# puts week.bottle_necks.map{|i| i.int}.inspect

week.assign_staffs	
puts "daily_assignment_records!!!!!!!!!!!!!!!!!!!!!"
week.schedule.each{|day| puts "Day:#{day.int}, m:#{day.morning_shift.count}, n: #{day.night_shift.count}, need:#{day.night_roles_needed.inspect}"}


puts "employee_assignment_records!!!!!!!!!!!!!!!!!!!!!!"
staffs.each do |e|
	puts "#{e.first_name} required:#{e.minimum_days_required.inspect} filled:#{e.days_assigned.count}, prim: #{e.roles[:primary]}, sec: #{e.roles[:secondary]}"
	puts ""
end

puts "daily staff"
week.schedule.sort_by{|d| d.int}.each do |day|
	puts day.morning_shift.map{|e|e.first_name}.inspect
	puts day.night_shift.map{|e|e.first_name}.inspect
	puts "" 
end

# week.schedule.each do |key,val|
# 	day = val[:day].map{|i| "#{i.first_name}: #{i.roles_text}, #{i.days_assigned.count}, #{i.minimum_days_required}"}
# 	night = val[:night].map{|i| "#{i.first_name}: #{i.roles_text}, #{i.days_assigned.count}, #{i.minimum_days_required}"}
# 	puts "#{key}: day:#{day}"
# 	puts "headcount #{day.count}"
# 	puts "  night:#{night}"
# 	puts "headcount #{night.count}"
# 	puts ""
# end

# require './config/environment'
# require './weekday.rb'
# require 'benchmark'

# staffs = Employee.all

# staffs.each do |e|
# 	e.update(days_assigned_text: "")
# end

class Schedule
	attr_accessor :priorities, :schedule, :all_combos
	attr_reader :staffs, :default_needs, :staffs_by_min_days_required, :all_staffs_id

	def initialize(staffs)
		@staffs = staffs
		@staffs_by_min_days_required = {}
		staffs.each{|e| staffs_by_min_days_required[e.id] = e.minimum_days_required}
		# @days_unassigned = [1,2,3,4,5,6,7]
		@schedule = new_schedule
		@all_combos = []
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

	def all_roles_filled?(team,primary_roles)
		roles = {}
		["host","kitchen","buser","delivery"].each{|r| roles[r]=[]}
		team.each do |employee|
			roles[employee.roles[:primary]] << employee
			roles[employee.roles[:secondary]] << employee
		end
		return false if roles.values.any?{|r| r.empty?}
		true
	end

	def passed_initial_filter?(team)
		primary_roles = team.map{|e| e.roles[:primary]}
		#bad if dont have 2 uniq roles
		return false if primary_roles.uniq.count < 2		
		#bad if dont have primary kitchen or host
		return false if !primary_roles.include?("kitchen") && !primary_roles.include?("host")
		#bad if all roles not filled by primary or secondary
		return false if !all_roles_filled?(team,primary_roles)
		true
	end

	def reduce_qualified_to_10(teams,day)
		selected = teams
		
		#eliminate all combo with less than 3 primary roles
		selected.delete_if do |team|
			primary_roles = team.map{|e| e.roles[:primary]}
			primary_roles.uniq.count < 3
		end
		return selected if selected.count <= 10

		#eliminate all combo where no one can work on morning 
		selected.delete_if do |team| 
			team.none? do |e| 
				e.morning_avail.include?(day.int)  &&
				(e.roles[:primary] == "kitchen" or e.roles[:primary] == "host")
			end
		end
		selected
	end

	def score_by_flex(teams)
		teams.sort_by{|team| team.map{|e| e.flex_score}.inject(:+)}.pop(6)
	end

	def qualify_teams(day)
		night_roles = day.night_roles_needed
		morning_roles = day.morning_roles_needed

		employees = day.night_avail
		combos = employees.combination(4).to_a

		filtered = []
		combos.each do |team|
			filtered << team if passed_initial_filter?(team)
		end

		if filtered.count > 10
			filtered = reduce_qualified_to_10(filtered,day)
		end

		if filtered.count > 6
			filtered = score_by_flex(filtered)
		end
		filtered
	end

	def update_all_combos(filtered)
		if self.all_combos == []
			filtered.each{|team| self.all_combos << [team]}
		else
			new_all_combos = []
			self.all_combos.each do |week|
				# puts week[0].map{|e|e.first_name}.inspect
				new_week = []
				filtered.each do |day|
					new_week = week.clone << day
					new_all_combos << new_week
					new_week = []
				end
			end
			self.all_combos = new_all_combos.clone
			# puts self.all_combos.last.map{|day| day.map{|e| e.first_name}}.inspect
		end
	end

	def passed_min_days_required_test(all_week)
	 	self.staffs_by_min_days_required.each do |id,minimum_days_required|
			return false if ((minimum_days_required - all_week.count(id)).abs > 1)
		end
		true
	end

	def filter_all_combo
		employees = self.staffs.map{|e| e.id}
		max = 0
		filtered = []
		time = Benchmark.measure do 
			self.all_combos.each do |week|
				all_week = week.flatten.map{|e| e.id}
				if (employees - all_week).empty? && passed_min_days_required_test(all_week)
					point = score_week(week,all_week)
					if point > max
						max = point
						filtered = [week]
					elsif point == max
						filtered << week
					end
				end
			end
		end
		puts time
		puts filtered.count
		puts "max !!!!!!!!!!!!!!!!!!!!!!!!!!!!!    #{max}"
		filtered
	end 

	def score_week(week , all_week)
		point = 0
		self.staffs_by_min_days_required.each do |id,minimum_days_required|
			difference = minimum_days_required - all_week.count(id)
			point += 1 if difference == 0
			point -= 1 if difference < 0
		end

		week.each_with_index do |employees, idx|
			day = idx + 1
			employees.each do |e|
				if e.full_time
					point += 1 if e.preferred_days.include?(day)
					point += 2 if all_week.count(e.id) == 5
					point -= 5 if day == 1
				end
				point += 1 if e.preferred_days.include?(day)
				point += 1 if e.morning_avail.include?(day)
			end
		end
		point
	end

	def generate
		point = 1
		optimal_sch = [] 
		# time = Benchmark.measure do
			schedule.each do |day|
				filtered = qualify_teams(day)
				update_all_combos(filtered)
			end
		# end
		# puts time
		puts self.all_combos.count
		
		# time = Benchmark.measure do
			optimal_sch = filter_all_combo
		# end
		# puts time
		optimal_sch.each do |week|
			week.each do |day|
				puts day.map{|e| e.first_name}.inspect
			end
			# puts ""
			# puts "...."
		end
		optimal_sch
	end

	def assign(day,employee)
		employee.update(days_assigned_text: (employee.days_assigned << day).join(","))
	end
end

# week = Schedule.new(staffs) 
# day1 = week.schedule[0]
# day2 = week.schedule[1]
# day3 = week.schedule[2]
# day4 = week.schedule[3]
# day5 = week.schedule[4]
# day6 = week.schedule[5]
# day7 = week.schedule[6]

# week.qualify_teams(week.schedule[2])
# week.optimal_combo(day1)
# week.optimal_combo(day2)
# week.generate
# week.all_combos.each{|week| puts week.map{|day| day.map{|e| e.first_name}}.inspect}
# combos.each{|team| puts team.map{|e| e.first_name}.inspect}
# puts week.score(combos[0],day) == -1
# team_1 = [8,7,6,3]
# team_1.map!{|i| Employee.find(i)}
# roles_1 = team_1.map{|e| e.roles[:primary]}

# team_2 = [8,7,6,5]
# team_2.map!{|i| Employee.find(i)}
# roles_2 = team_2.map{|e| e.roles[:primary]}

# team_mon = [8,7,5,4].map{|i| Employee.find(i)}
# team_tue = [8,1,2,4].map{|i| Employee.find(i)}
# team_wed = [1,3,7,5].map{|i| Employee.find(i)}
# team_thur = [1,3,5,4].map{|i| Employee.find(i)}
# team_fri = [1,3,5,9].map{|i| Employee.find(i)}
# team_sat = [1,3,9].map{|i| Employee.find(i)}
# team_sun = [8,3,5,6].map{|i| Employee.find(i)}

# puts "Test No.1 all_roles_filled? and passed_filter"
# puts week.all_roles_filled?(team_1,roles_1) == false
# puts week.passed_initial_filter?(team_1) == false
# puts "Test No.2 all_roles_filled? and passed_filter"
# puts week.all_roles_filled?(team_2,roles_2) == true
# puts week.passed_initial_filter?(team_2) == true

# puts week.qualify_teams(day1).any?{|team| (team - team_mon).count == 0}
# puts week.qualify_teams(day2).any?{|team| (team - team_tue).count == 0}
# puts week.qualify_teams(day3).any?{|team| (team - team_wed).count == 0}
# puts week.qualify_teams(day4).any?{|team| (team - team_thur).count == 0}
# puts week.qualify_teams(day5).any?{|team| (team - team_fri).count == 0}
# puts week.qualify_teams(day7).any?{|team| (team - team_sun).count == 0}
# puts week.qualify_teams(day6).any?{|team| (team - team_sat).count ==1}	 

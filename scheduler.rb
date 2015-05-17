require './seed'

staffs = Array.new(9){generate_employee}

=begin 
normal = 4 people working, 1 host, 1 buser, 1 deliery, 1 kitchen #jeff is here
full_time employee, get priority

base on minimum_days_required, and current opening and roles, assign

1. who is avalible
2. who is available at day. if more than 2, eval by default_roster
3. ppl work in day, also work at night
2. what roles are avaliable 
3. what roles do I need, 
4. select min from minimum_days_required
6. select by preferred day
5. rating
=end
Default_roster = ["host","buser","delivery","kitchen"]
week = [1,2,3,4,5,6,7]
week1 = {}
week.each{|k| week1[k] = {day: [],night: []}}

def assign_day_staff(staff_array)
  return staff_array if staff_array.count <= 2
  roles = ["host","kitchen"]
  options = staff_array.select{|i| roles.include?(i.roles[:primary]) or roles.include?(i.roles[:secondary])}
  
  if options.count > 2
    return options.sample(2)
  end
  options
end

def filter_by_roles(staff_array,roles)
  staff_array.select do |emp|
    roles.include?(emp.roles[:primary]) or roles.include?(emp.roles[:secondary])
  end
end

def assign_night_staff(day_staffs,free_night_staffs)
  free_night_staffs = free_night_staffs - day_staffs
  filled_roles = day_staffs.map{|i| i.roles[:primary]}.uniq
  if filled_roles.count == 1
    filled_roles << day_staffs.map{|i| i.roles[:secondary]}.sample(1)
  end
  needed_roles = Default_roster.dup - filled_roles
  # how good the people already selected? 
  free_night_staffs = filter_by_roles(free_night_staffs,needed_roles)
  if free_night_staffs <= 2
    return free_night_staffs
  else
    free_night_staffs.sort_by{|i| i.minimum_days_required}.pop(2)
  end
end



week1.each do |key,val|
  free_day_staffs = []
  free_night_staffs = []
  staffs.each do |emp|
    free_day_staffs << emp if emp.day_availabilities.include?(key)
    free_night_staffs << emp if emp.night_availabilities.include?(key)
  end
  
  val[:day] = assign_day_staff(free_day_staffs)
  
  val[:night] = assign_night_staff(val[:day],free_night_staffs)

end



week1[1].each{|k,v| v.each{|i| p k.to_s+ ":" +i.first_name}}
# full_time = staffs.select{|i| i.full_time}
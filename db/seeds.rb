require 'faker'
# class Employee 
#   attr_accessor :first_name, :last_name, :preferred_days, :minimum_days_required,
#   :roles, :day_availabilities, :night_availabilities, :phone,:full_time
#   def initialize(data={})
#     @first_name = data["first_name"]
#     @last_name = data["last_name"]
#     @preferred_days = data["preferred_days"]
#     @minimum_days_required = data["minimum_days_required"]
#     @roles=data["roles"]
#     @phone = data["phone"]
#     # @perks=data["perks"]
#     @day_availabilities = data["day_availabilities"]
#     @night_availabilities = data["night_availabilities"]
#     @full_time = data["full_time"]
#     @assigned = 0
#   end
# end

# employee = {
#   "first_name" => "kevin",
#   "last_name" => "xu",
#   "preferred_days" => [1,2],
#   "minimum_days_required" => 2,
#   "roles"=> {primary: 'host', secondary: 'buser'},
#   "night_availabilities" => [1,2,3,4,5,6,7],
#   "day_availabilities"=>[2,3,4]
# }

# # puts employee
# kev = Employee.new(employee)
# t.string   :first_name
# t.string   :last_name
# t.integer  :minimum_days_required
# t.string   :phone_number
# t.boolean  :full_time
# t.integer  :days_assigned

def generate_employee

  days = [1,2,3,4,5,6,7]
  roles = ["host", "buser", "delivery", "kitchen"]
  n = rand(1..5)
  na = days.sample(n+2)
  tasks = roles.sample(2)
  
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
  
  minimum_days_required = n
  tasks = tasks
  full_time = (n == 5)? true : false
  phone_number = Faker::PhoneNumber.cell_phone
  
  employee = Employee.create(first_name: first_name, last_name: last_name, minimum_days_required: minimum_days_required, phone_number: phone_number, full_time: full_time)

  employee.day_availabilities = na.take(rand(0..na.count))
  employee.night_availabilities = na
  employee.preferred_days = na.sample(n)
  employee.roles = {primary: tasks[0], secondary: tasks[1]}

end



10.times do 
  generate_employee
end
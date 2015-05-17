require 'faker'

class Employee 
  attr_accessor :first_name, :last_name, :preferred_days, :minimum_days_required,
  :roles, :day_availabilities, :night_availabilities, :phone,:full_time
  def initialize(data={})
    @first_name = data["first_name"]
    @last_name = data["last_name"]
    @preferred_days = data["preferred_days"]
    @minimum_days_required = data["minimum_days_required"]
    @roles=data["roles"]
    @phone = data["phone"]
    # @perks=data["perks"]
    @day_availabilities = data["day_availabilities"]
    @night_availabilities = data["night_availabilities"]
    @full_time = data["full_time"]
    @assigned = 0
  end
end


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

def generate_employee

  days = [1,2,3,4,5,6,7]
  roles = ["host", "buser", "delivery", "kitchen"]
  n = rand(1..5)
  na = days.sample(n+2)
  tasks = roles.sample(2)
  employee = {
  "first_name" => Faker::Name.first_name,
  "last_name" => Faker::Name.last_name,
  "minimum_days_required" => n,
  "night_availabilities" => na,
  "preferred_days" => na.sample(n),
  "day_availabilities" => na.take(rand(0..na.count)),
  "tasks" => tasks,
  "roles" => {primary: tasks[0], secondary: tasks[1]},
  "full_time" => (n == 5)? true : false
  }
  Employee.new(employee)
end




=begin 
normal = 4 people working, 1 host, 1 buser, 1 deliery, 1 kitchen #jeff is here
full_time employee, get priority

base on minimum_days_required, and current opening and roles, assign

1. who is avalible
2. what roles are avaliable 
3. what roles do I need, 
4. select min from minimum_days_required
6. select by preferred day
5. rating
=end



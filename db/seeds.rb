require 'faker'
# def generate_employee
#   days = [1,2,3,4,5,6,7]
#   roles = ["host", "buser", "delivery", "kitchen"]
#   n = rand(1..5)
#   na = days.sample(n+2)
#   tasks = roles.sample(2)
  
#   first_name = Faker::Name.first_name
#   last_name = Faker::Name.last_name
  
#   minimum_days_required = n
#   tasks = tasks
#   full_time = (n == 5)? true : false
#   phone_number = Faker::PhoneNumber.cell_phone
  
#   employee = Employee.create(
#     first_name: first_name, 
#     last_name: last_name, 
#     minimum_days_required: minimum_days_required, 
#     phone_number: phone_number, 
#     full_time: full_time,
#     day_availabilities_text: na.take(rand(0..na.count)).join(","),
#     night_availabilities_text:  na.join(","),
#     preferred_days_text: na.sample(n).join(","),
#     roles_text: tasks.join(",")
#     )
# end

Employee.create(
  first_name: "Matt",
  last_name: "Matt",
  minimum_days_required: 5,
  phone_number: Faker::PhoneNumber.cell_phone,
  full_time: true,
  morning_avail_text: [1,2,3,4,5,6,7].join(","),
  night_avail_text: [1,2,3,4,5,6,7].join(","),
  preferred_days_text: [2,3,4,5,6].join(","),
  roles_text: ["host","buser"].join(",")
  )

Employee.create(
  first_name: "Justin",
  last_name: "Justin",
  minimum_days_required: 3,
  phone_number: Faker::PhoneNumber.cell_phone,
  full_time: false,
  morning_avail_text: "",
  night_avail_text: [1,2,3,4,5,6,7].join(","),
  preferred_days_text: [1,2,3].join(","),
  roles_text: ["buser","delivery"].join(",")
  )

Employee.create(
  first_name: "Derrick",
  last_name: "Derrick",
  minimum_days_required: 5,
  phone_number: Faker::PhoneNumber.cell_phone,
  full_time: true,
  morning_avail_text: [1,2,3,4,5,6,7].join(","),
  night_avail_text: [1,2,3,4,5,6,7].join(","),
  preferred_days_text: [3,4,5,6,7].join(","),
  roles_text: ["host","kitchen"].join(",")
  )

Employee.create(
  first_name: "Kevin",
  last_name: "Kevin",
  minimum_days_required: 3,
  phone_number: Faker::PhoneNumber.cell_phone,
  full_time: false,
  morning_avail_text: "",
  night_avail_text: [1,2,4,5,6,7].join(","),
  preferred_days_text: [2,4,6,7].join(","),
  roles_text: ["kitchen","delivery"].join(",")
  )

Employee.create(
  first_name: "Daemon",
  last_name: "Daemon",
  minimum_days_required: 4,
  phone_number: Faker::PhoneNumber.cell_phone,
  full_time: false,
  morning_avail_text: "",
  night_avail_text: [1,2,3,4,5,6,7].join(","),
  preferred_days_text: [1,2,4,7].join(","),
  roles_text: ["delivery","buser"].join(",")
  )

Employee.create(
  first_name: "Godfrey",
  last_name: "Godfrey",
  minimum_days_required: 1,
  phone_number: Faker::PhoneNumber.cell_phone,
  full_time: false,
  morning_avail_text: "",
  night_avail_text: [6,7].join(","),
  preferred_days_text: [7].join(","),
  roles_text: ["kitchen","buser"].join(",")
  )

Employee.create(
  first_name: "Paul",
  last_name: "Paul",
  minimum_days_required: 3,
  phone_number: Faker::PhoneNumber.cell_phone,
  full_time: false,
  morning_avail_text: [1,3,6].join(","),
  night_avail_text: [1,3,6].join(","),
  preferred_days_text: [1,3,6].join(","),
  roles_text: ["host","buser"].join(",")
  )

Employee.create(
  first_name: "Taylor", 
  last_name: "Taylor",
  minimum_days_required: 3,
  phone_number: Faker::PhoneNumber.cell_phone,
  full_time: false,
  morning_avail_text: [2].join(","),
  night_avail_text: [1,2,7].join(","),
  preferred_days_text: [1,2,7].join(","),
  roles_text: ["host","host"].join(",")
  )

Employee.create(
  first_name: "Jerry",
  last_name: "Jerry",
  minimum_days_required: 2,
  phone_number: Faker::PhoneNumber.cell_phone,
  full_time: false,
  morning_avail_text: "",
  night_avail_text: [5,6].join(","),
  preferred_days_text: [5,6].join(","),
  roles_text: ["kitchen","buser"].join(",")
  )

Employee.create(
  first_name: "New_Guy",
  last_name: "New_Guy",
  minimum_days_required: 2,
  phone_number: Faker::PhoneNumber.cell_phone,
  full_time: false,
  morning_avail_text: "",
  night_avail_text: [1,3,5].join(","),
  preferred_days_text: [1,3,5].join(","),
  roles_text: ["delivery","host"].join(",")
  )
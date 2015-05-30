  
get '/' do
	@staffs = Employee.all

	erb :generate 
end

get '/time' do
	puts params
	staffs = params["ids"].map{|i| Employee.find(i)}
	week = Schedule.new(staffs)
	time = week.time_est

	json :data => time
end

get '/new_schedule' do
	ids = params["ids"].split(",")
	all_staffs = ids.map{|i| Employee.find(i)}
	working_staffs= all_staffs.select{|e| e.minimum_days_required > 0}
	backup_staffs = all_staffs.select{|e| e.minimum_days_required == 0}
	week = Schedule.new(working_staffs)
	@schedule = prepare_for_view(week.generate,working_staffs,backup_staffs).sample 

	erb :schedule
end

get '/employees' do 
	@staffs = Employee.all
	erb :employees
end 

post '/edit/:id' do
	data = organize_data(params)
	id=params["id"]
	employee = Employee.find(id) 
	employee.update(data)

	redirect "/employees"
end 

get '/new_employee' do
	erb	:new_employee
end

post '/new_employee' do 
	data = organize_data(params)
	Employee.create(data)
	if Employee.where(first_name: data[:first_name])
		redirect "/employees"
	else
		erb :error
	end
end

post '/delete_employee' do
	Employee.destroy(params["id"])
end
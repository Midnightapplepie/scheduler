  
get '/' do
	@staffs = Employee.all

	erb :generate 
end

get '/new_schedule' do
	ids = params["ids"].split(",")
	staffs = ids.map{|i| Employee.find(i)}
	week = Schedule.new(staffs)
	@schedule = prepare_for_view(week.generate,staffs).sample 

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
  
get '/' do
	"Hello World"

	@staffs = Employee.all
	schedule = Schedule.new(@staffs)
	@generated_schedule = schedule.generate
	@week = display_sched(@generated_schedule[0])

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
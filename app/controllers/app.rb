  
get '/' do
	"Hello World"

	@staffs = Employee.all
	schedule = Schedule.new(@staffs)
	@generated_schedule = schedule.generate
	@week = display_sched(@generated_schedule[0])

	erb :schedule
end
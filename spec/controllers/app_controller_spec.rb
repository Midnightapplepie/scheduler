require 'spec_helper'
# require './db/seeds.rb'

describe 'employees controller' do

	it 'should return all employees' do
		employees = Employee.all
		names = []
		employees.each{|e| names << e.first_name} 
		get '/employees'
		expect(last_response.status).to eq 200
		expect(employees.count).to eq 8
		names.each do |name|
			expect(last_response.body).to include(name)
		end
	end

end

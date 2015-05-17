class CreateEmployees < ActiveRecord::Migration
  def change
  	create_table :employees do |t|
  		t.string   :first_name
  		t.string   :last_name
  		t.integer  :minimum_days_required
  		t.string   :phone_number
  		t.boolean  :full_time
  		t.integer  :days_assigned, :default => 0

  		t.timestamps
  	end
  end
end

class CreateEmployees < ActiveRecord::Migration
  def change
  	create_table :employees do |t|
  		t.string   :first_name
  		t.string   :last_name
  		t.integer  :minimum_days_required
  		t.string   :phone_number
  		t.boolean  :full_time
  		t.string  :days_assigned_text, :default => ""
      t.string   :morning_avail_text
      t.string   :night_avail_text
      t.string   :roles_text
      t.string   :preferred_days_text

  		t.timestamps
  	end
  end
end

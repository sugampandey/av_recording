class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.integer :wday
      t.time :start_time
      t.time :end_time
      t.boolean :enabled, :default => false

      t.timestamps
    end
  end
end

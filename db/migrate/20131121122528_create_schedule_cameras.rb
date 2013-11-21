class CreateScheduleCameras < ActiveRecord::Migration
  def change
    create_table :schedule_cameras do |t|
      t.integer :schedule_id
      t.integer :camera_id
    end
  end
end

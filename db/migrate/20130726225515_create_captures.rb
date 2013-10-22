class CreateCaptures < ActiveRecord::Migration
  def change
    create_table :captures do |t|
      t.integer :camera_id
      t.datetime :start_time
      t.datetime :end_time
      t.string :time_zone
      t.string :state
      t.attachment :video

      t.timestamps
    end
  end
end

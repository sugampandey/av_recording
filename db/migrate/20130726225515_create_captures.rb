class CreateCaptures < ActiveRecord::Migration
  def change
    create_table :captures do |t|
      t.integer :camera_id
      t.datetime :start_time
      t.datetime :end_time
      t.string :time_zone
      t.string :state
      t.string :video_file_name
      t.string :video_content_type
      t.integer :video_file_size
      t.datetime :video_updated_at
      t.timestamps
    end
  end
end

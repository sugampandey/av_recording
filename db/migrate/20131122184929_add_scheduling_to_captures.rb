class AddSchedulingToCaptures < ActiveRecord::Migration
  def change
    add_column :captures, :recurrent, :boolean, :default => false
    remove_column :captures, :video_file_name, :string
    remove_column :captures, :video_content_type, :string
    remove_column :captures, :video_file_size, :integer
    remove_column :captures, :video_updated_at, :datetime
  end
end

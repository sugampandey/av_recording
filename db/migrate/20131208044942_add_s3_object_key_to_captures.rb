class AddS3ObjectKeyToCaptures < ActiveRecord::Migration
  def change
    add_column :captures, :s3_object_key, :string
  end
end

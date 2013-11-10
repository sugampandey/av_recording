class AddJobIdToCaptures < ActiveRecord::Migration
  def change
    add_column :captures, :job_id, :string
  end
end

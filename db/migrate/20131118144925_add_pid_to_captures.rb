class AddPidToCaptures < ActiveRecord::Migration
  def change
    add_column :captures, :pid, :string
  end
end

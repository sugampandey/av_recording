class CreateCameras < ActiveRecord::Migration
  def change
    create_table :cameras do |t|
      t.string :name
      t.string :host_uri
      t.string :capture_path
      t.string :username
      t.string :password

      t.timestamps
    end
  end
end

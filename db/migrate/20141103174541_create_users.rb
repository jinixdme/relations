class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.integer :mother_id

      t.timestamps
    end
  end
end

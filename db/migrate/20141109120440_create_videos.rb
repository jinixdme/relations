class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :title
      t.string :engine
      t.integer :duration

      t.timestamps
    end
  end
end

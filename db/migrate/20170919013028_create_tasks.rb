class CreateTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :tasks do |t|
      t.datetime :datetime
      t.time :start_time
      t.time :end_time
      t.string :title
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end

class CreateTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :tasks do |t|
      t.datetime :start_at
      t.datetime :end_at
      t.string :title
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end

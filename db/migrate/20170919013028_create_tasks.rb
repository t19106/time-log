class CreateTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :tasks do |t|
      t.date :date
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end

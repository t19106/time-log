class CreateTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :tasks do |t|
      t.datetime :starts_at
      t.datetime :ends_at
      t.string :memo
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end

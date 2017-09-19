class CreateSubtasks < ActiveRecord::Migration[5.1]
  def change
    create_table :subtasks do |t|
      t.string :title
      t.time :time
      t.references :task, foreign_key: true
      t.timestamps
    end
  end
end

class CreateGoals < ActiveRecord::Migration[5.1]
  def change
    create_table :goals do |t|
      t.references :tag, foreign_key: true
      t.interval :time

      t.timestamps
    end
  end
end

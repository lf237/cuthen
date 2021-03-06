class CreateItineraries < ActiveRecord::Migration
  def up
    create_table :itineraries do |t|
      t.string :name
      t.belongs_to :user, index: true
      t.text :description
      t.datetime :start_datetime
      t.datetime :end_datetime

      t.timestamps
    end
  end

  def down
    drop_table :itineraries
  end
end
class CreateParticipations < ActiveRecord::Migration
  def change
  	create_table :participations do |t|
      t.integer :user_id, null: false
      t.integer :meetup_id, null: false
      t.boolean :organizer?, default: false
    end
  end
end

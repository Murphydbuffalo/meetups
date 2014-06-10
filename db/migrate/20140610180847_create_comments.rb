class CreateComments < ActiveRecord::Migration
  def change
  	create_table :comments do |t|
      t.string :body, null: false
      t.integer :user_id, null: false
      t.integer :meetup_id, null: false
      t.timestamp 
    end
  end
end

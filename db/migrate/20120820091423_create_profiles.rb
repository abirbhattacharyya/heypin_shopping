class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
    	t.integer :user_id
      t.string :name
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :zip
      t.string :phone
      t.string :website	
      t.timestamps
    end
  end
end

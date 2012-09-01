class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|    	
      t.integer :user_id
      t.string :prodcut_id
      t.string :email
      t.float :price
      t.string :transaction_id
      t.string :first_name
      t.string :last_name
      t.string :street1
      t.string :street2
      t.string :city
      t.string :state
      t.string :country
      t.string :postal_code
      t.string :phone_number      
      t.string :card_type
      t.integer :card_number,:limit => 6
      t.integer :cc_expiry_month
      t.integer :cc_expiry_year
      t.integer :status,:default => 0	      
      t.timestamps
    end
  end
end

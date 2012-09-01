class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
    	t.integer :user_id
    	t.string :name
    	t.text :description
    	t.float :price    	      
    end
    add_attachment :products,:image_1
    add_attachment :products,:image_2
    add_attachment :products,:image_3
  end
end

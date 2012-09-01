class CreateProductImages < ActiveRecord::Migration
  def change
    create_table :product_images do |t|
    	t.integer :product_id
    end
    add_attachment :product_images,:image
  end
end

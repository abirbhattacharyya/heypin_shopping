class RemoveImagesFromProducts < ActiveRecord::Migration
  def up
  	remove_attachment :products,:image_1
    remove_attachment :products,:image_2
    remove_attachment :products,:image_3
  end

  def down
  	add_attachment :products,:image_1
    add_attachment :products,:image_2
    add_attachment :products,:image_3
  end
end

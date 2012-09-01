class AddFieldsInUsers < ActiveRecord::Migration
  def up
  	add_column :users,:name,:string
  	add_column :users,:fb_uid,:string  	
  end

  def down
  	remove_column :users,:name,:string
  	remove_column :users,:fb_uid,:string  	
  end
end

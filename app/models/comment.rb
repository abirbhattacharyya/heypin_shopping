class Comment < ActiveRecord::Base
	belongs_to :user
	belongs_to :product
  attr_accessible :product,:comment


  validates_presence_of :comment
end
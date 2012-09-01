class Product < ActiveRecord::Base
   belongs_to :user
   has_many :product_images, :dependent => :destroy
   has_many :comments,:dependent => :destroy
   has_many :product_likes,:dependent => :destroy
#   has_many :offers

  validates_presence_of :name, :message => "Hey, name can't be blank"
  validates_presence_of :description, :message => "Hey, description can't be blank"
  validates_presence_of :price, :message => "Hey, price can't be blank"
  validates_uniqueness_of :name, :scope => [:user_id, :price], :message => "Hey, name already been taken"

  attr_accessor :ip_address

  attr_accessible :name,:description,:price,:image_remote_url,:image_1 

  def color
    self.color_description.gsub(/\d+/, '').strip
  end
  
  def show_name
    str = self.name
    str += " by #{self.author}" if self.product_type == TYPES[:ebooks]
    str
  end
  
  def single_image_url
      image = self.product_images.first
      return image.image.url
  end

  
end

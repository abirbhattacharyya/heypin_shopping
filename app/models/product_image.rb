class ProductImage < ActiveRecord::Base
  belongs_to :product
	attr_accessor :image_remote_url
   attr_accessible :image,:image_remote_url

   before_validation :download_remote_image, :if => :image_url_provided?

  validates_attachment :image, :content_type => {:message => "Hey, Upload a JPEG, GIF, or PNG image please!", :content_type => ["image/jpg", "image/png", "image/gif", "image/bmp", "image/jpeg"] },
  :size => { :in => 0..5.megabytes }


  has_attached_file :image, {
  :path => ":rails_root/public/products/images/:id/:style/:filename",
  :url => "/products/images/:id/:style/:filename",
  :default_url => "/assets/mylogo.jpg",
   :styles => { :medium => "250x" }
  }


  private

  def image_url_provided?
    !self.image_remote_url.blank?
  end

  def download_remote_image
    self.image = do_download_remote_image
  end

  def do_download_remote_image
    io = open(image_remote_url)
    def io.original_filename; base_uri.path.split('/').last; end
    io.original_filename.blank? ? nil : io
  rescue => e # catch url errors with validations instead of exceptions (Errno::ENOENT, OpenURI::HTTPError, etc...)
    puts "-"*50
     puts  "Error: #{e}"
  end
end

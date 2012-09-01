# Load the rails application
require File.expand_path('../application', __FILE__)
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
# Initialize the rails application
# Initialize the rails application
HeypinShopping::Application.initialize!

MAX_IMAGES = 3
Rails.application.config.middleware.use OmniAuth::Builder do
 case Rails.env
  when 'development'
    provider :facebook, "147984555267190", "721e47d9fff31dd5dee44bb37f11b1d2", {:scope => 'offline_access,email'}
  when 'production'
    provider :facebook, "229605390495804", "d488c25dd7f008d9c5106264296a6b1e", {:scope => 'offline_access,email'}
 end
  
  # provider :facebook, FB_APP_ID, FB_API_SECRET, {:scope => 'offline_access,email'}
  # # provider :twitter, TWITTER_CONSUMER_KEY, TWITTER_CONSUMER_SECRET
  
end
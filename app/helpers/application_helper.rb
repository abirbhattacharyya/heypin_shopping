# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TextHelper

   def rand_code(limit)
    str1 = ("a".."z").to_a + ("0".."9").to_a
    arr1 = []
    (1..limit).each { |i| arr1 << str1[rand(999)%str1.length] }
    return arr1.to_s
  end

  def get_cart_products
    return [] if session[:cart].nil? || session[:cart].empty?
    products = Product.where("id IN (?)",session[:cart])
    products
  end

  def plural(num, text)
    pluralize(num, text)
  end

  def to_currency(number, options = {})
    return number_to_currency(number, options)
  end

  def date_format(datetime)
    return nil if datetime.nil?
    format = datetime.strftime("%m-%d-%Y")
    format
  end

  def with_delimiter(number, options = {})
    return number_with_delimiter(number, options)
  end
  def analytics_details(from, to)
    gs = Gattica.new({:email => 'dealkat@gmail.com', :password => "princessthecat", :profile_id => 61710247})
    results = gs.get({:start_date => from.to_s, :end_date => to.to_s,
                :dimensions => ['medium', 'source'], :metrics => ['pageviews', 'visits', 'timeOnSite'], :sort => '-pageviews'})
    @xml_data = results.to_xml
    @data = Hpricot::XML(@xml_data)
    analytics = {}
    (@data/'dxp:aggregates').each do |aggregate|
      (aggregate/'dxp:metric').each do |metric|
          analytics["pageviews"] = metric[:value] if metric[:name] == "ga:pageviews"
          analytics["visits"] = metric[:value] if metric[:name] == "ga:visits"
          analytics["timeOnSite"] = metric[:value] if metric[:name] == "ga:timeOnSite"
      end
    end
    return analytics
  end
  
end

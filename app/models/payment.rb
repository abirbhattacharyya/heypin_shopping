class Payment < ActiveRecord::Base
   attr_accessible :first_name,:last_name,:email,:postal_code,:country
   attr_accessible :card_number,:cc_expiry_m1,:cc_expiry_m2,:cvv,:card_type, :cc_expiry_year


  validates_presence_of :first_name, :message => "^Hey, first name can't be blank"#,:on => :update
  validates_presence_of :last_name, :message => "^Hey, last name can't be blank"#,:on => :update
  validates_presence_of :email, :message => "^Hey, e-mail address can't be blank"#,:on => :update
  validates_presence_of :postal_code, :message => "^Hey, zip can't be blank"#,:on => :update

  attr_accessor :cc_expiry_m1, :cc_expiry_m2,:name,:agreement, :cvv

  STATUS = {
    :pending => 0,
    :success => 1,
    :fail => 2
  }
  PURCHASE_TYPE = {
  	:add_to_cart => 1,
  	:buy => 2
  }
  Months = {
    "JANUARY" => 1,
    "FEBRUARY" => 2,
    "MARCH" => 3,
    "APRIL" => 4,
    "MAY" => 5,
    "JUNE" => 6,
    "JULY" => 7,
    "AUGUST" => 8,
    "SEPTEMBER" => 9,
    "OCTOBER" => 10,
    "NOVEMBER" => 11,
    "DECEMBER" => 12,
  }
  # CARD_TYPES = ["Visa", "Maestro", "MasterCard", "American Express"]
  CARD_TYPES = [["Visa", "visa"], ["MasterCard", "master"], ["Discover", "discover"], ["American Express", "american_express"]]


  def self.month_options(from)
    options = Hash.new
    Months.each_key do |k|
      next if Months[k.to_s].to_i < from
      options[k.to_s]=Months[k.to_s]
    end
    return options.sort {|a,b| a[1]<=>b[1]}
  end

   def name
     self.first_name + " " + self.last_name
   end

   def cc_number_last_digit(n)
    number = self.card_number - 42891
    last_digits = number.to_s[-n,n]
    last_digits
  end
  def purchase(price)
    response = GATEWAY.purchase(price_in_cents(price), credit_card,purchase_options)
    if response.success?
       self.transaction_id = response.params['transaction_id']
       # self.card_number = self.card_number + 42891
       self.status = STATUS[:success]
       save
       [true,nil]
    else
      self.status = STATUS[:fail]
      save
      [false,response.message]
    end
  end

  def price_in_cents(price)

    price_in_dollar = price * 1

    (price_in_dollar*100).round
  end

  def validate_card
    if credit_card.valid?
      return true
    else
      credit_card.errors.each do |error|
        field = 
          if(error[0].downcase == "number") 
            "Credit Card Number" 
          elsif(error[0].downcase == "type") 
            "Card Type"
          elsif(error[0].downcase == "verification_value") 
            "Security Code"
          else
            error[0]
          end
        errors.add(field, error[1])
      end

      return false
    end
  end


  private
 def purchase_options
    {
      :ip => '127.0.0.1',
      :billing_address => {
        :country  => country,
        :zip      => postal_code
      }
    }
  end
  def credit_card
    @credit_card ||= ActiveMerchant::Billing::CreditCard.new(
      :type               => card_type,
      :number             => card_number,
      :verification_value => cvv,
      :month              => cc_expiry_month,
      :year               => cc_expiry_year,
      :first_name         => first_name,
      :last_name          => last_name
    )
  end

end

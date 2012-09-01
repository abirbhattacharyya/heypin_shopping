class Notification < ActionMailer::Base
  add_template_helper(ApplicationHelper)
  default_url_options[:host] = "iudeal.com"
  SENDER = '"iudeal" <no-reply@iudeal.com>'

  def forgot(user)
    subject    'Your forgotten password for Heyprice'
    recipients user.email
    from       SENDER

    body       :user => user
    sent_on    Time.now
  end

  def sendto(recipient, product, name, message)
    subject    'Say your price'
    #recipients recipient
    bcc recipient
    from       SENDER

    body      :product => product, :name => name, :message => message
    sent_on    Time.now
  end

  def sendcoupon(recipient, payment)
    subject    'here\'s your test voucher'
    #recipients recipient
    bcc recipient
    from       SENDER
#    reply_to   "custserv@gap.com"

    body      :payment => payment
    sent_on    Time.now
  end
  
  def payment_mail_to_consumer(recipient, payment)
    subject    'Your Perry South Beach Hotel Reservation'
    #recipients recipient
    bcc recipient
    from       SENDER

    body      :payment => payment
    sent_on    Time.now
    content_type 'text/html'
  end

  def payment_mail_to_merchant(recipient, payment)
    subject    'Confirmed Dealkat Reservation'
    #recipients recipient
    bcc recipient
    from       SENDER

    body      :payment => payment
    sent_on    Time.now
    content_type 'text/html'
  end

  def send_daily_report(start_date,today,today_negotiations,cumulative_negotiations,today_sales,cumulative_sales,today_total_sales,cumulative_total_sales)
    subject    'daily report'
    #recipients recipient
    bcc ADMINS
    from      SENDER

    body      :start_date => start_date,:today => today,:today_negotiations => today_negotiations,:cumulative_negotiations => cumulative_negotiations, :today_sales => today_sales ,:cumulative_sales => cumulative_sales, :today_total_sales => today_total_sales, :cumulative_total_sales => cumulative_total_sales
    sent_on    Time.now
    content_type 'text/html'
  end 
end

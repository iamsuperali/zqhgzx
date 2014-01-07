# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
FishCms::Application.initialize!

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address        => "smtp.163.com",
  :port           => 25,
  :domain         => "www.163.com",
  :authentication => :login,
  :user_name      => "fishcms@163.com",
  :password       => "13602953927"
}



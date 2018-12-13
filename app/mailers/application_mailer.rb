class ApplicationMailer < ActionMailer::Base
  default from: ENV["DEF_GMAIL"]
  layout "mailer"
end

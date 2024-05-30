# app/mailers/thank_you_mailer.rb
class ThankYouMailer < ApplicationMailer
  def send_thank_you_email
    require 'sendgrid-ruby'

    from = SendGrid::Email.new(email: 'pbhqkoc8z@mozmail.com')
    to = SendGrid::Email.new(email: user.email)
    subject = 'Merci pour votre commande !'
    content = SendGrid::Content.new(type: 'text/plain', value: 'Merci d\'avoir passé votre commande chez nous. Nous vous enverrons votre adorable photo de chaton très bientôt.')
    mail = SendGrid::Mail.new(from, subject, to, content)

    sg = SendGrid::API.new(api_key: ENV['SENDGRID_PASSWORD'])

    begin
      response = sg.client.mail._('send').post(request_body: mail.to_json)
      puts response.status_code
      puts response.body
      puts response.headers
    rescue Exception => e
      puts e.message
    end
  end
end

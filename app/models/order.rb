class Order < ApplicationRecord
  belongs_to :user
  after_create :send_thank_you_email

  has_many :order_items, dependent: :destroy
  has_many :items, through: :order_items

  def send_thank_you_email
    require 'sendgrid-ruby'

    from = SendGrid::Email.new(email: 'pbhqkoc8z@mozmail.com')
    to = SendGrid::Email.new(email: user.email)
    subject = 'Merci pour votre commande !'

    html_content = <<-HTML
    <!DOCTYPE html>
    <html>
    <head>
    <meta content='text/html; charset=UTF-8' http-equiv='Content-Type' />
    </head>
    <body>
    <h1>Merci pour votre commande!</h1>
    <p>Bonjour,</p>
    <p>Nous vous confirmons que votre commande a été passée avec succès. Voici les détails de votre commande :</p>
    <div>
    <h2>Produit acheté :</h2>
    <h3><%= @item.title %></h3>
    <img src="<%= attachments['product_image.jpg'].url %>">
    <p>Prix : <%= number_to_currency(@item.price) %></p>
    <!-- Autres détails du produit -->
    </div>
    <!-- Autres informations sur la commande, telles que l'adresse de livraison, etc. -->
    <p>Merci de votre achat!</p>
    </body>
    </html>
    HTML

    # Utilisation de SendGrid::Content pour envoyer du HTML
    content = SendGrid::Content.new(type: 'text/html', value: html_content)
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

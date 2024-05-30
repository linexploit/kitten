class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :items, through: :order_items

  # Méthode pour marquer la commande comme payée
  def mark_as_paid
    update(status: 'succeeded')
    send_emails if saved_change_to_status? && status == 'succeeded'
  end

  private

  def send_emails
    send_thank_you_email
    send_admin_notification_email
  end

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
        <% order_items.each do |order_item| %>
          <h3><%= order_item.item.title %></h3>
          <p>Prix : <%= number_to_currency(order_item.item.price) %></p>
        <% end %>
      </div>
      <p>Merci de votre achat!</p>
    </body>
    </html>
    HTML

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

  def send_admin_notification_email
    require 'sendgrid-ruby'

    from = SendGrid::Email.new(email: 'pbhqkoc8z@mozmail.com')
    to = SendGrid::Email.new(email: 'celinebrezin@gmail.com')
    subject = 'Nouvelle commande passée'

    html_content = <<-HTML
    <!DOCTYPE html>
    <html>
    <head>
      <meta content='text/html; charset=UTF-8' http-equiv='Content-Type' />
    </head>
    <body>
      <h1>Nouvelle commande passée</h1>
      <p>Bonjour,</p>
      <p>Une nouvelle commande a été passée. Voici les détails de la commande :</p>
      <div>
        <h2>Détails de la commande :</h2>
        <% order_items.each do |order_item| %>
          <h3><%= order_item.item.title %></h3>
          <p>Prix : <%= number_to_currency(order_item.item.price) %></p>
        <% end %>
        <p>Total : <%= number_to_currency(order_items.sum { |order_item| order_item.item.price }) %></p>
      </div>
      <p>Merci de vérifier les détails de cette commande!</p>
    </body>
    </html>
    HTML

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

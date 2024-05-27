class Item < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  has_many :carts, through: :cart_items
  has_many :order_items
  has_many :orders, through: :order_items

  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  #validates :image_url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]) }
end

class User < ApplicationRecord
  after_create :create_cart

  has_one :cart, dependent: :destroy
  has_many :orders, dependent: :destroy
  after_create :create_cart
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable



end

class User < ApplicationRecord
  after_create :create_cart
  has_one_attached :profile_picture
  has_one :cart, dependent: :destroy
  has_many :orders, dependent: :destroy
  after_create :create_cart
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

         validate :acceptable_profile_picture

         def acceptable_profile_picture
           return unless profile_picture.attached?

           acceptable_types = ["image/jpeg", "image/png"]
           unless acceptable_types.include?(profile_picture.content_type)
             errors.add(:profile_picture, "must be a JPEG or PNG")
           end
         end

end

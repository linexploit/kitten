# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'faker'

require 'open-uri'

Item.destroy_all

kitten_pictures = [
  "https://projetchatonss.s3.eu-west-3.amazonaws.com/kitten_pics/5845e0f37733c3558233c0e9.png",
  "https://projetchatonss.s3.eu-west-3.amazonaws.com/kitten_pics/angry-cat-angry-cat-meme.jpg",
  "https://projetchatonss.s3.eu-west-3.amazonaws.com/kitten_pics/angry-cat-meme.jpg",
  "https://projetchatonss.s3.eu-west-3.amazonaws.com/kitten_pics/cat-funny.jpg",
  "https://projetchatonss.s3.eu-west-3.amazonaws.com/kitten_pics/cat-memes-funny.jpg",
  "https://projetchatonss.s3.eu-west-3.amazonaws.com/kitten_pics/cat.jpg",
  "https://projetchatonss.s3.eu-west-3.amazonaws.com/kitten_pics/coughing-cat-meme-lede.jpg",
  "https://projetchatonss.s3.eu-west-3.amazonaws.com/kitten_pics/crying-cat.jpg",
  "https://projetchatonss.s3.eu-west-3.amazonaws.com/kitten_pics/meme-pictures-f1v85crzl8ku35dr.jpg",
  "https://projetchatonss.s3.eu-west-3.amazonaws.com/kitten_pics/flying+cat"
]

20.times do
  Item.create!(
    title: Faker::Creature::Cat.name,
    description: Faker::Lorem.paragraph(sentence_count: 3),
    price: Faker::Commerce.price(range: 10.0..100.0, as_string: true).to_d,
    image_url: Faker::LoremFlickr.image(size: "300x300", search_terms: ['cat'])
  )
end

puts "20 cat-items created"

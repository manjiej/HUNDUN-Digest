# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "Cleaning all database.."

Summary.destroy_all
User.delete_all
ActsAsTaggableOn::Tag.destroy_all

puts "Creating database..."

category_list = ['Business', 'Culture', 'Economics', 'Education', 'Environment', 'Politics', 'Society', 'Science', 'Technology']

category_list.each do |tag|
  ActsAsTaggableOn::Tag.new(:name => tag).save
end

# User.create(email: "hillary@gmail.com", password: "123123", photo: "data:image/jpeg;base64,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")
# User.create(email: "steve@gmail.com", password: "123123", photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQrmlG2d77LS7GLnlNG26Bman5AmpWeiMmCrSRw978nvajFchizQg&s")
# User.create(email: "mark@gmail.com", password: "123123", photo: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTnn0THQcqaRmzyt7CY65Lm-hTJ0ipD1R6pnqb4LToXSciDSVtr&s")

# Summary.create(article_url: "https://m.ftchinese.com/premium/001085449?exclusive")
# Summary.create(article_url: "https://cn.engadget.com/2019/12/02/stellar-black-hole-is-larger-than-science-expected/")
# Summary.create(article_url: "https://cn.engadget.com/2013/05/23/logitech-wired-ipad-keyboard/")
# Summary.create(article_url: "https://cn.engadget.com/2019/12/05/nasa-parker-solar-probe-results/")

puts "Database successfully created!"

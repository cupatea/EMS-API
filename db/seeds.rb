# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
user = User.create! email: "ems@email.com", password: "password"
user.events.create! name: "User event", time: Time.now+7.days, place: "Some place",  purpose: "Some purpose" , owner_id: user.id

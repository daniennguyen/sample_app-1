User.create!(
  name: "Truong Dang Quang",
	email: "quangjacger99@gmail.com",
	password: "thisisme",
	password_confirmation: "thisisme",
	admin: true,
	activated: true,
	activated_at: Time.zone.now)

99.times do |n|
  User.create!(
    name: Faker::Name.name,
    email: "example-#{n+1}@railstutorial.org",
    password: "password",
    password_confirmation: "password",
    activated: true,
    activated_at: Time.zone.now)
end

users = User.order(:created_at).take 6
50.times do
	content = Faker::Lorem.sentence(5)
	users.each { |user| user.microposts.create! content: content }
end

users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow followed }
followers.each { |follower| follower.follow user }

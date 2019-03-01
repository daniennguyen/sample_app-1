User.create!
	name: "Mother fucker",
	email: "motherfucker@motherfucker.com",
	password: "motherfucker",
	password_confirmation: "motherfucker",
	admin: true,
	activated: true,
	activated_at: Time.zone.now

users = User.order(:created_at).take(6)
50.times do
	users.each { |user| 
		user.microposts.create! content: Faker::Lorem.sentence(5)
	}
end

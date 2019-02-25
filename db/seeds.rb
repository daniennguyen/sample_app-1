User.create!(name:  "Trương Đăng Quang",
  email: "quangjacger99@gmail.com",
  password: "thisisme",
  password_confirmation: "thisisme",
  admin: true)

99.times do |n|
  password = 
  User.create!(
    name: Faker::Name.name + "#{n+1}",
    email: "example-#{n+1}@railstutorial.org",
    password: "password",
    password_confirmation: "password")
end

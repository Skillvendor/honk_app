User.create!(name:  "Lucian",
             email: "Skillvendor193@gmail.com",
             password:              "parola",
             password_confirmation: "parola",
             admin: true,
             activated: true)

99.times do |n|
  name  = Faker::Name.name
  email = "Skillvendor-#{n+1}@gmail.com"
  password = "parola"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true)
end

users = User.order(:created_at).take(6)
20.times do
  content = Faker::Lorem.sentence(5)
  users.each { |user| user.tweets.create!(content: content) }

end

users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }

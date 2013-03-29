namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    User.create username: "goggin13",
                email: "goggin13@gmail.com",
                first: "Matt",
                last: "Goggin"

    100.times do |n|
      user = User.create!(username: Faker::Internet.user_name.gsub('.', ''),
                          first: Faker::Name.first_name,
                          last: Faker::Name.last_name,
                          email: Faker::Internet.email)
      puts "Created new user, #{user.username}"
      25.times do |i|
        post = user.posts.create!({title: Faker::Lorem.words(4).join(' '),
                                   content: Faker::Lorem.paragraphs(3).join("\n")})
      end
    end
  end
end

namespace :db do
  desc "Fill database with sample data"
  
  def random_time
    t1 = Time.now.advance(years: -2)
    t2 = Time.now
    Time.at((t2.to_f - t1.to_f) * rand + t1.to_f)
  end
  
  task populate: :environment do
    User.destroy_all
    Tag.destroy_all
    Post.destroy_all
    
    User.create username: "goggin13", password: "password"
    
    tags = (0..20).map do |n|
      Tag.create! name: Faker::Lorem.words(1)[0]
    end
    
    100.times do |n|
      user = User.create!(username: Faker::Internet.user_name.gsub('.', ''),
                          password: "password",
                          bio: Faker::Lorem.paragraphs(1))
      user.created_at = random_time
      user.save!
      puts "Created new user, #{user.username}"
      25.times do |i|
        post = user.posts.create!({title: Faker::Company.bs,
                                   content: Faker::Lorem.paragraphs(3).join("\n")})
        4.times { post.add_tag tags.shuffle[0] }
        post.created_at = random_time
        post.save!
      end
    end
  end
end

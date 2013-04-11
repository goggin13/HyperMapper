namespace :db do
  desc "Fill database with sample data"
  
  def random_time
    t1 = Time.now.advance(years: -2)
    t2 = Time.now
    Time.at((t2.to_f - t1.to_f) * rand + t1.to_f)
  end
  
  task populate: :environment do
    # User.destroy_all
    # Tag.destroy_all
    # Post.destroy_all
    
    User.create! username: "goggin13", password: "password"
    
    tags = (0..20).map do |n|
      Tag.create! name: Faker::Lorem.words(1)[0]
    end
    
    user_ids = []

    50.times do |n|
      user = User.create!(username: Faker::Internet.user_name.gsub('.', ''),
                          password: "password",
                          bio: Faker::Lorem.paragraphs(1)[0])
      user_ids << user.id
      user.created_at = random_time.to_i
      if user.save
        puts "Created new user, #{user.id} | #{user.username}"
      else
        puts "failed"
      end
      1.times do |i|
        post = user.posts.create!(title: Faker::Company.bs,
                                  content: Faker::Lorem.paragraphs(3).join("\n"))
        4.times { post.add_tag tags.shuffle[0] }
        puts post.valid?
        post.created_at = random_time.to_i
        if post.save
          # puts "new post #{post.title}"
        else
          puts "failed to create post"
        end

        10.times { 
          c = post.comments.create! text: Faker::Lorem.words(12).join(" "),
                                    user_id: user_ids.shuffle[0]
          c.created_at = random_time.to_i
          puts "COMMENT FAILED" if !c.save
        }
      end
    end
  end
end

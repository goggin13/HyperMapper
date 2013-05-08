namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    
    system User.destroy_space
    system User.create_space
    
    (0..10000).each do |i|
      user = User.new(username: "user-#{i}", _id: i)
      if (user.save)
        puts "created #{user.username}"
        success = (0..25).inject(true) do |acc, j|
          post = user.posts.build title: "post #{i}-#{j}", 
                                  content: "the blog post content for #{i}-#{j}",
                                  _id: j
          acc && post.save
        end
        puts "\t#{success ? "created" : "failed to create"} 25 posts"
      else 
        user.errors.full_messages.each { |e| puts e }
      end
    end
  end
end

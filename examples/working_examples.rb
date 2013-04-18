$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib")) 
require '/home/goggin/projects/rails/hyper_mapper/lib/hyper_mapper'

path = "/home/goggin/projects/rails/hyper_mapper/examples/config.yml"
HyperMapper::Config.load_from_file path

class Post
  include HyperMapper::Document

  autogenerate_id
  attribute :title
  attribute :content
  
  timestamps
  
  embedded_in :user
end

class User
  include HyperMapper::Document

  key :username
  attribute :email

  embeds_many :posts
end

user = User.create! username: 'goggin13', email: 'goggin13@gmail.com'

puts user

user = User.find('goggin13')
puts user.first
puts user.last

user.first = 'george'
user.save
puts User.find('goggin13').email

post = Post.new id: 1, title: "hello world", content: "safsafd"
user.posts << post
puts post
post.save

post = User.find('goggin13').posts.first
puts post.title
puts post.content

post.title = "a new title!"
post.save

puts User.find('goggin13').posts.first.title

user.posts.create! title: 'My new post', content: 'more great content'
user = User.find('goggin13')

puts "#{user.username} has #{user.posts.length} posts now"
user.posts.each do |p|
  puts "\t#{p.title} : #{p.content}"
end

User.all.each do |u|
  puts u.username
end


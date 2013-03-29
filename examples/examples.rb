
class User
  include HyperMapper::Document

  key :username
  attribute :first
  attribute :last
  attribute :phone, :type => :int
  attribute :hobbies, :type => :string_set
  attribute :lucky_numbers, :type => :integer_set
  attribute :likes, :type => :map, 
                    :keys => :string, 
                    :values => :integer
  
  timestamps

  has_many :posts
  has_many :comments
end

class Post
  include HyperMapper::Document

  auto_generate_id
  attribute :body
  attritube :title
  timestamps

  belongs_to :user 
  embeds_many :comments
  has_and_belongs_to_many :tags, through: ArticleTag
end

class Tag
  include HyperMapper::Document

  key :name

  has_and_belongs_to_many :posts, through: ArticleTag
end

class ArticleTag
  include HyperMapper::Document

  autogenerate_id
  attribute :article_id
  attribute :tag_name
end

class Comment
  include HyperMapper::Document
  
  auto_generate_id
  attribute :username
  attribute :body

  timestamps

  belongs_to :user

  embedded_in :post
end

# Create a new user
user = User.create! username: 'goggin13'

# Create a new post for that user
post = user.posts.create! title: 'A post', content: 'hello world'

# Two ways to add tags to a post
tag = Tag.create! name: 'programming'
post.tags << tag
post.tags.create! name: 'Cornell'

# JSON representation of a post
puts post.to_json

# XML representation of a user
puts user.to_xml

# Raises KeyModificationError
user.username = "a new username"
user.save!

# Auto maintained fields
puts user.created_at
puts user.updated_at

# Sorted in memory
Post.where(created_at: [Time.now.to_i, 
                        Time.now.advance(months: 1).to_i],
           order: :created_at,
           sort: :desc)



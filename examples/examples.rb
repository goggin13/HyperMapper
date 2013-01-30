
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
  
  has_many :posts
  has_many :comments
end

class Post
  include HyperMapper::Document

  attribute :body
  attritube :title
  
  belongs_to :user 
  embeds_many :comments
  has_and_belongs_to_many :tags
end

class Comment
  include HyperMapper::Document
  
  attribute :username
  attribute :body
  
  belongs_to :user

  embedded_in :post
end

class Tag
  include HyperMapper::Document

  key :name

  has_and_belongs_to_many :posts
end

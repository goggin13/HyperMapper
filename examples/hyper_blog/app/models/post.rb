require 'hyper_mapper'

class Post
  include HyperMapper::Document

  attr_accessor :tag_string
  
  attr_accessible :title, :content, :user_id, :tag_string

  autogenerate_id
  attribute :title
  attribute :content
  attribute :user_id
  timestamps

  validates :title, presence: true

  belongs_to :user

  embeds_many :comments  
  has_and_belongs_to_many :tags, through: :post_tags
  
  before_save :update_tags
    
  def formatted_tags
    tags.collect(&:name).join ', ' 
  end
  
  def add_tag(tag)
    tags << tag unless tags.include? tag
  end
  
  def update_tags
    return unless tag_string
    new_tag_names = tag_string.split(",").map { |t| t.strip.downcase }
    new_tag_names.each do |tag_name| 
      tag = Tag.where(name: tag_name)[0]
      tag = Tag.create! name: tag_name unless tag
      add_tag tag 
    end
    tags.each { |t| (tags.remove t) unless (new_tag_names.include? t.name) }
  end
end

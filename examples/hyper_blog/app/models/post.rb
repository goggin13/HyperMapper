require 'hyper_mapper'

class Post
  include HyperMapper::Document

  attr_accessor :tag_string
  
  key :id, autogenerate: true
  attribute :title
  attribute :content
  attribute :user_id
  timestamps

  belongs_to :user

  embeds_many :comments  
  # has_and_belongs_to_many :tags
  
  # before_save :update_tags
    
  def formatted_tags
    # tags.collect(&:name).join ', ' 
    ""
  end
  
  def add_tag(tag)
    tags << tag unless tags.include? tag
  end
  
  def update_tags
    return unless tag_string
    new_tag_names = tag_string.split(",").map { |t| t.strip.downcase }
    new_tag_names.each do |tag_name| 
      add_tag tags.find_or_create_by_name(tag_name) 
    end
    tags.each { |t| (tags.delete t) unless (new_tag_names.include? t.name) }
  end
end

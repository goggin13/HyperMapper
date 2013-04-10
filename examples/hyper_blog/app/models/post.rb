class Post < ActiveRecord::Base
  attr_accessor :tag_string
  attr_accessible :content, :title, :tag_string
  
  belongs_to :user
  
  has_and_belongs_to_many :tags
  
  before_save :update_tags
    
  def formatted_tags
    tags.collect(&:name).join ', ' 
  end
  
  def update_tags
    new_tag_names = tag_string.split(",").map { |t| t.strip.downcase }
    new_tag_names.each do |tag_name| 
      t = tags.find_or_create_by_name(tag_name) 
      tags << t unless tags.include? t
    end
    tags.each { |t| (tags.delete t) unless (new_tag_names.include? t.name) }
  end
end

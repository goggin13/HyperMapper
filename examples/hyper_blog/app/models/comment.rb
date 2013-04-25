require 'hyper_mapper'

class Comment
	include HyperMapper::Document
	
	attr_accessible :user_id, :text

	autogenerate_id
	attribute :text
	attribute :user_id
	
	timestamps
	
	belongs_to :user
	embedded_in :post
end
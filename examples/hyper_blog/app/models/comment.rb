class Comment
	include HyperMapper::Document
	
	autogenerate_id
	attribute :text
	attribute :user_id
	
	timestamps
	
	belongs_to :user
	embedded_in :post
end
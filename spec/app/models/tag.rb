class Tag
  include HyperMapper::Document
  key :name
  has_and_belongs_to_many :articles
end

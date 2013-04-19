module HyperMapper
  module Document
     module ClassMethods
       def timestamps
         attribute :created_at, type: :datetime
         attribute :updated_at, type: :datetime
        
         before_create do
           self.created_at = Time.now.to_i
         end

         before_save do
           self.updated_at = Time.now.to_i
         end
       end
    end
  end
end

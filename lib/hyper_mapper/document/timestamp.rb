module HyperMapper
  module Document
     module ClassMethods
       def timestamps
         attribute :created_at
         attribute :updated_at
          
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

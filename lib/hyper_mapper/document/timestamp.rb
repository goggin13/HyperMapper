module HyperMapper
  module Document
     module ClassMethods
       def timestamps
         attribute :created_at
         attribute :updated_at
         
         alias_method :created_at_raw, :created_at
         define_method :created_at_to_time do
           Time.at(created_at_raw)
         end
         alias_method :created_at, :created_at_to_time

         alias_method :updated_at_raw, :updated_at
         define_method :updated_at_to_time do
           Time.at(updated_at_raw)
         end
         alias_method :updated_at, :updated_at_to_time
        
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

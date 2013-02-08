

module HyperMapper
  module Persistence
    module ClassMethods 
      def create(params={})
        
      end
      
      def create!(params={})
        HyperMapper::Config.client.put("users", "goggin", {email: 'matt@example.com'})
      end 
    end
  end
end

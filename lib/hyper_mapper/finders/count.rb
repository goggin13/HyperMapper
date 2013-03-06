
module HyperMapper
  module Finders 
    def count(predicate={})
      HyperMapper::Config.client.count(space_name, predicate)
    end
  end
end

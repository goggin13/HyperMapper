
module HyperMapper
  module Finders 
    
    def where(params={})
      results = HyperMapper::Config.client.search(space_name, params)
      results.map { |r| load_from_attrs(r) }
    end

    def load_from_attrs(attrs)
      self.new(attrs)
    end
  end
end


module HyperMapper
  module Finders 
    
    def find(key)
      result = HyperMapper::Config.client.get(space_name, key)
      return load_from_attrs(result) if result

      nil
    end

    def where(params={})
      results = HyperMapper::Config.client.search(space_name, params)
      results.map { |r| load_from_attrs(r) }
    end

    def load_from_attrs(attrs)
      self.new(attrs)
    end
  end
end


module HyperMapper
  module Finders 
    
    def find(key)
      result = HyperMapper::Config.client.get(space_name, key)
      if result
        result[key_name] = key
        return load_from_attrs(result) 
      end

      nil
    end

    def where(params={})
      order = params.delete :order
      sort = params.delete :sort
      results = HyperMapper::Config.client.search(space_name, params)
      if order
        if sort == :desc
          results.sort! { |b, a| a[order] <=> b[order] }
        else
          results.sort! { |a, b| a[order] <=> b[order] }
        end
      end

      results.map { |r| load_from_attrs(r) }
    end

    def all(params={})
      where params
    end

    def load_from_attrs(attrs={}, new_record=false)
      instance = self.new(attrs)
      instance.persisted = true
      instance
    end
  end
end

require 'hyperclient'

module HyperDex

  class Client
    
    def initialize(options)
      @address = options['host']
      @port = options['port']
      @client = HyperClient.new @address, @port
    end

    def get(space, key)   
      r = @client.get space, key
      r
    end

    def put(space, key, attrs) 
      formatted = attrs.map { |k,v| 
        k = k.to_s if k.is_a? Symbol
        v = v.to_s if v.is_a? Symbol
        [k, v] 
      }
      # puts "#{space} : #{key} => #{formatted}"
      @client.put space, key, formatted 
    end

    def delete(space, key) 
      @client.del space, key
    end
    
    def search(space, predicate)
      predicate = predicate.inject({}) { |acc, (k, v)| 
        k = k.to_s if k.is_a? Symbol
        acc[k] = v
        acc
      }
      # puts "search #{space} => #{predicate}"
      r = @client.search space, predicate
      arr = []
      while r.has_next
        arr << r.next
      end

      arr
    end

    def map_remove(space, key, map_key)
      # puts "map_remove #{space} - #{key} - #{map_key}"
      @client.map_remove space, key, map_key
    end
    
    def map_add(space, key, map_value)
      # puts "map_add #{space} - #{key} - #{map_value}"
      @client.map_add space, key, map_value
    end

    def multi_get(space, keys, id_name='id') 
      keys.map do |key|
        [(@client.async_get space, key), key]
      end.map do |arr|
        deferredObject = arr[0]
        r = deferredObject.wait()
        r[id_name] = arr[1]
        r
      end
    end
    
    def async_get(space, key) 
      @client.async_get space, key
    end
    
    def add_space(spec)
      @client.add_space spec
    end
    
    def rm_space(spec)
      @client.rm_space spec
    end
    
    def cond_put(space, key, condition, attrs) end
    def atomic_add(space, key, value) end
    def atomic_sub(space, key, value) end
    def atomic_div(space, key, value) end
    def atomic_mod(space, key, value) end
    def atomic_and(space, key, value) end
    def atomic_or(space, key, value) end
    def atomic_xor(space, key, value) end
    def string_prepend(space, key, value) end
    def string_append(space, key, value) end
    def list_lpush(space, key, value) end
    def list_rpush(space, key, value) end
    def set_add(space, key, value) end
    def set_remove(space, key, value) end
    def set_intersect(space, key, value) end
    def set_union(space, key, value) end
    def map_atomic_add(space, key, value) end
    def map_atomic_sub(space, key, value) end
    def map_atomic_mul(space, key, value) end
    def map_atomic_div(space, key, value) end
    def map_atomic_mod(space, key, value) end
    def map_atomic_and(space, key, value) end
    def map_atomic_or(space, key, value) end
    def map_atomic_xor(space, key, value) end
    def map_string_prepend(space, key, value) end
    def map_string_append(space, key, value) end
    def async_put(space, key, value) end
    def async_cond_put(space, key, condition, value) end
    def async_delete(space, key) end
    def async_atomic_add(space, key, value) end
    def async_atomic_sub(space, key, value) end
    def async_atomic_mul(space, key, value) end
    def async_atomic_div(space, key, value) end
    def async_atomic_mod(space, key, value) end
    def async_atomic_and(space, key, value) end
    def async_atomic_or(space, key, value) end
    def async_atomic_xor(space, key, value) end
    def async_string_prepend(space, key, value) end
    def async_string_append(space, key, value) end
    def async_list_lpush(space, key, value) end
    def async_list_rpush(space, key, value) end
    def async_set_add(space, key, value) end
    def async_set_remove(space, key, value) end
    def async_set_intersect(space, key, value) end
    def async_map_atomic_add(space, key, value) end
    def async_map_atomic_sub(space, key, value) end
    def async_map_atomic_mul(space, key, value) end
    def async_map_atomic_div(space, key, value) end
    def async_map_atomic_mod(space, key, value) end
    def async_map_atomic_and(space, key, value) end
    def async_map_atomic_or(space, key, value) end
    def async_map_atomic_xor(space, key, value) end
    def async_map_string_prepend(space, key, value) end
    def async_map_string_append(space, key, value) end
    def async_set_union(space, key, value) end
    def loop() end
  end
end

module HyperDex

  class Client
    
    def initialize(options)
      @address = options['host']
      @port = options['port']
    end

    def get(space, key) end
    def put(space, key, attrs) end
    def cond_put(space, key, condition, attrs) end
    def delete(space, key) end
    def search(space, predicate) end
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
    def async_get(space, key) end
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

begin
  require 'hyperclient'
rescue LoadError
  puts 'You need to install HyperDex with Ruby bindings enabled'
end

module HyperMapper
  module Config
   
    def client=(c)
      @client = c
    end

    def client
      @client ||= HyperDex::Client.new(HyperMapper::Config.config)
    end
    
    def config
      @config || defaults
    end

    def defaults
      @defauts ||= load_defaults
    end

    def default_config_path
      "lib/hyper_mapper/config/config.yml"
    end
    
    def load_from_file(path)
      @client = nil
      @config = YAML.load(File.read(path))
    end

    def load_defaults
      load_from_file default_config_path
    end

    def path
      config['path'] || 'hyperdex'
    end    
  end
end

module HyperMapper
  module Config
    
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
      @config = YAML.load(File.read(path))
    end

    def load_defaults
      load_from_file default_config_path
    end
  end
end

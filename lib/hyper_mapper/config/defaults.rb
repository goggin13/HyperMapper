module HyperMapper
  module Config
    
    def config
      defaults
    end

    def defaults
      @defauts ||= load_defaults
    end

    def default_config_path
      "lib/hyper_mapper/config/config.yml"
    end

    def load_defaults
      YAML.load(File.read(default_config_path))
    end
  end
end

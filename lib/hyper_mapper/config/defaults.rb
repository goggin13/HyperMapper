module HyperMapper
  module Config

    def defaults
      @defauts ||= load_defaults
    end

    def default_config_path
      "lib/hyper_mapper/config/config.yml"
    end

    def load_defaults
      YAML.load(ERB.new(File.read(default_config_path)).result)
    end
  end
end

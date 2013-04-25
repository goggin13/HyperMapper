
module HyperMapper
  module Config
   
    def client=(c)
      @client = c
    end

    def client
      @client ||= HyperDex::Client.new(HyperMapper::Config.config)
    end
  end
end

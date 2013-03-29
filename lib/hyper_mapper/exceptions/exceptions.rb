

module HyperMapper
  module Exceptions
    class HyperMapperError < StandardError; end
    class IllegalKeyModification < HyperMapperError; end
    class MissingArgumentError < HyperMapperError; end
  end
end

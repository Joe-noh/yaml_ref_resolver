class YamlRefResolver
  class YamlNotFoundException < StandardError
    attr_reader :path

    def initialize(path:)
      @path = path

      super("yaml file not found: #{path}")
    end
  end

  class YamlSyntaxErrorException < StandardError
    attr_reader :original_exception

    def initialize(exception:)
      @original_exception = exception

      super("syntax error #{@original_exception.message}")
    end
  end
end

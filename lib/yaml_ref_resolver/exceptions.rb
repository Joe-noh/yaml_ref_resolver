class YamlRefResolver
  class YamlNotFoundException < StandardError
    attr_reader :path

    def initialize(path:)
      @path = path

      super("yaml file not found: #{path}")
    end
  end
end

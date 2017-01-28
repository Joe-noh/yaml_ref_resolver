require "yaml_ref_resolver"
require "optparse"

class YamlRefResolver
  class CLI
    def initialize
      @opt = OptionParser.new
      @input = nil

      define_options
    end

    def run(argv)
      @opt.parse!(argv)

      resolver = YamlRefResolver.new
      yaml = resolver.resolve(@input)

      $stdout.write(yaml.to_yaml)
    end

    private

    def define_options
      @opt.on('-v', '--version', 'show version number.') do
        puts "YamlRefResolver v#{YamlRefResolver::VERSION}"
        exit
      end

      @opt.on('-i path', '--input', 'entry point path') do |path|
        @input = path
      end
    end
  end
end

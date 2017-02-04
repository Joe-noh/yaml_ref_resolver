require "yaml_ref_resolver"
require "optparse"
require "filewatcher"

class YamlRefResolver
  class CLI
    def initialize
      @opt = OptionParser.new
      @input = nil

      define_options
    end

    def run(argv)
      @opt.parse!(argv)
      validate_input_path

      if @glob
        FileWatcher.new(@glob).watch do |filename|
          resolver.reload(File.expand_path(filename))
          resolve_and_dump
        end
      else
        resolve_and_dump
      end
    end

    private

    def resolve_and_dump
      yaml = resolver.resolve(@input)
      $stdout.write(yaml)
    end

    def resolver
      @resolver ||= YamlRefResolver.new(key: @key)
    end

    def define_options
      @opt.on('-v', '--version', 'show version number.') do
        puts "YamlRefResolver v#{YamlRefResolver::VERSION}"
        exit
      end

      @opt.on('-i path', '--input', 'entry point path') do |path|
        @input = path
      end

      @opt.on('-k key', '--key', 'key to be resolved. $ref by default') do |key|
        @key = key
      end

      @opt.on('-w glob', '--watch', 'glob pattern to watch cahnges') do |glob|
        @glob = glob
      end
    end

    def validate_input_path
      unless @input
        puts "please specify input yaml with --input option"
        exit 1
      end

      unless File.exists?(@input)
        puts "#{@input} not found"
        exit 1
      end
    end
  end
end

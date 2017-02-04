require "yaml_ref_resolver"
require "optparse"
require "filewatcher"

class YamlRefResolver
  class CLI
    def initialize
      @opt = OptionParser.new
      @input = nil
      @output = nil
      @watch = false

      define_options
    end

    def run(argv)
      @opt.parse!(argv)
      validate_input_path

      resolve_and_dump

      if @watch
        FileWatcher.new(resolver.files).watch do |filename|
          resolver.reload(File.expand_path(filename))
          resolve_and_dump
        end
      end
    end

    private

    def resolve_and_dump
      yaml = resolver.resolve(@input).to_yaml

      if @output
        File.open(@output, "w") do |f|
          f.puts yaml
        end
      else
        $stdout.write yaml
      end
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

      @opt.on('-o path', '--output', 'output file path') do |path|
        @output = path
      end

      @opt.on('-k key', '--key', 'key to be resolved. $ref by default') do |key|
        @key = key
      end

      @opt.on('-w', '--watch', 'glob pattern to watch cahnges') do
        @watch = true
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

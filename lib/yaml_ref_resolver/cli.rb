require "yaml_ref_resolver"
require "json"
require "optparse"
require "filewatcher"

class YamlRefResolver
  class CLI
    def initialize
      @opt = OptionParser.new
      @input = nil
      @output = nil
      @watch = false
      @json = false

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
      if @output
        File.open(@output, "w") do |f|
          f.puts resolved_yaml_or_json
        end
      else
        $stdout.write resolved_yaml_or_json
      end
    end

    def resolved_yaml_or_json
      if @json
        JSON.pretty_generate resolver.resolve!(@input)
      else
        resolver.resolve!(@input).to_yaml
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

      @opt.on('-j', '--json', 'output in json format') do
        @json = true
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

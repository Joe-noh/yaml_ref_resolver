require "yaml_ref_resolver"
require "json"
require "optparse"

begin
  require "filewatcher"
rescue => LoadError
end

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

      if @watch
        resolve_and_dump
        FileWatcher.new(resolver.files).watch do |filename|
          resolve_and_dump(File.expand_path filename)
        end
      else
        exit(1) unless resolve_and_dump
      end
    end

    private

    def resolve_and_dump(changed_file = nil)
      resolver.reload!(changed_file)

      if @output
        File.open(@output, "w") do |f|
          f.puts resolved_yaml_or_json!
        end
        log "bundled successfully."
      else
        $stdout.write resolved_yaml_or_json!
      end

      return true
    rescue => e
      log e.message
      return false
    end

    def resolved_yaml_or_json!
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

      @opt.on('-w', '--watch', 'glob pattern to watch changes (needs filewatcher rubygem)') do
        unless defined? FileWatcher
          puts 'you need the `filewatcher` rubygem to watch for changes. You can run `gem install filewatcher` to install it.'
          exit 1
        end
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

      unless File.exist?(@input)
        puts "#{@input} not found"
        exit 1
      end
    end

    def log(message)
      puts "[#{Time.now}] #{message}"
    end
  end
end

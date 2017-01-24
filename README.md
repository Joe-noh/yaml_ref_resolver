# YamlRefResolver

This is a gem that resolves `$ref` references to other YAML files.

## Installation

Just add this line to your application's Gemfile and run `bundle install`.

```ruby
gem 'yaml_ref_resolver'
```

## Usage

```ruby
# specify entry point and resolve refs.
yaml = YamlRefResolver.resolve("example.yaml")

# dump yaml to a file.
yaml.write("output.yaml")
```

## Contributing

Bug reports and pull requests are very welcome on GitHub at https://github.com/Joe-noh/yaml_ref_resolver.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

# YamlRefResolver

[![Gem Version](https://badge.fury.io/rb/yaml_ref_resolver.svg)](https://badge.fury.io/rb/yaml_ref_resolver)

This is a gem that resolves `$ref` references to other YAML files.

## Installation

Just add this line to your application's Gemfile and run `bundle install`.

```ruby
gem 'yaml_ref_resolver'
```

## Usage

```ruby
resolver = YamlRefResolver.new

hash = resolver.resolve("index.yaml")
```

## Contributing

Bug reports and pull requests are very welcome on GitHub at https://github.com/Joe-noh/yaml_ref_resolver.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

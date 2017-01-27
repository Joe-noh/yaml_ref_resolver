# YamlRefResolver

[![Gem Version](https://badge.fury.io/rb/yaml_ref_resolver.svg)](https://badge.fury.io/rb/yaml_ref_resolver)
[![Build Status](https://travis-ci.org/Joe-noh/yaml_ref_resolver.svg?branch=master)](https://travis-ci.org/Joe-noh/yaml_ref_resolver)

This is a gem that resolves `$ref` references to other YAML files.

## Installation

Just add this line to your application's Gemfile and run `bundle install`.

```ruby
gem 'yaml_ref_resolver'
```

## Usage

Assume that we have following yaml files.

```yaml
# index.yaml
author:
  $ref: './john.yaml#/profile'
```

```yaml
# john.yaml
profile:
  name: John
  age: 28
```

This gem resolves `$ref` references.

```ruby
resolver = YamlRefResolver.new

hash = resolver.resolve('index.yaml')
#=> {'author' => {'name' => "john", 'age' => 28}}
```

Optionally you can specify the key.

```ruby
resolver = YamlRefResolver.new(key: '$import')
```

## Contributing

Bug reports and pull requests are very welcome on GitHub at https://github.com/Joe-noh/yaml_ref_resolver.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

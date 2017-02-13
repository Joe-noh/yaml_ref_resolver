# YamlRefResolver

[![Gem Version](https://badge.fury.io/rb/yaml_ref_resolver.svg)](https://badge.fury.io/rb/yaml_ref_resolver)
[![Build Status](https://travis-ci.org/Joe-noh/yaml_ref_resolver.svg?branch=master)](https://travis-ci.org/Joe-noh/yaml_ref_resolver)

This is a gem that resolves and expands `$ref` references to other YAML files.

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

### CLI

Give an entry point yaml with `-i` or `--input` option.

```console
$ yaml_ref_resolver -i ./path/to/index.yaml

# dump to stdout
```

Optionally output file path with `-o` or `--output` can be given.

```console
$ yaml_ref_resolver -i ./path/to/index.yaml -o ./path/to/output.yaml
```

`-w` or `--watch` option watches referenced yaml files and dump whole resolved yaml when one of them changed.

```console
$ yaml_ref_resolver -i ./path/to/index.yaml -w
```

`-j` or `--json` switch outputs in json format instead of yaml format.

```
$ yaml_ref_resolver -i ./path/to/index.yaml -j
```

## Contributing

Bug reports and pull requests are very welcome on GitHub at https://github.com/Joe-noh/yaml_ref_resolver.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

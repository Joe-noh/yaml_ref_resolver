# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yaml_ref_resolver/version'

Gem::Specification.new do |spec|
  spec.name = "yaml_ref_resolver"
  spec.version = YamlRefResolver::VERSION
  spec.authors = ["Joe-noh"]
  spec.email = ["goflb.jh@gmail.com"]

  spec.summary = "Resolves referencing to other YAML files."
  spec.homepage = "https://github.com/Joe-noh/yaml_ref_resolver"
  spec.license = "MIT"

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_dependency "filewatcher", "~> 1"

  spec.add_development_dependency "bundler", "~> 2"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "pry", "~> 0.10"
end

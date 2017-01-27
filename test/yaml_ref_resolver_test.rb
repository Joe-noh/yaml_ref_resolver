require 'test_helper'

class YamlRefResolverTest < Minitest::Test
  def setup
    @resolver = YamlRefResolver.new
  end

  def test_resolve_single_yaml
    path = File.join(File.dirname(__FILE__), *%w[yamls single.yaml])
    yaml = @resolver.resolve(path)

    assert_equal yaml, YAML.load_file(path)
  end

  def test_resolve_yaml_containing_object
    path = File.join(File.dirname(__FILE__), *%w[yamls object index.yaml])
    yaml = @resolver.resolve(path)

    assert_equal yaml['paths']['/products']['post']['tags'].first, 'product'
  end

  def test_resolve_yaml_containing_array
    path = File.join(File.dirname(__FILE__), *%w[yamls array index.yaml])
    yaml = @resolver.resolve(path)

    assert_equal yaml['produces'][0], 'application/json'
    assert_equal yaml['produces'][1], 'text/html'
  end

  def test_resolve_yaml_containing_deep_refs
    path = File.join(File.dirname(__FILE__), *%w[yamls deep index.yaml])
    yaml = @resolver.resolve(path)

    assert_equal yaml['paths']['/products']['post']['responses'][201]['description'], 'Successfully created.'
  end

  def test_custom_key
    resolver = YamlRefResolver.new(key: '$import')
    path = File.join(File.dirname(__FILE__), *%w[yamls custom_key index.yaml])
    yaml = @resolver.resolve(path)

    assert_equal yaml['paths']['/products']['post']['tags'].first, 'product'
  end
end

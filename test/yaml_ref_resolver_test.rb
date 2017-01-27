require 'test_helper'

class YamlRefResolverTest < Minitest::Test
  def test_resolve_single_yaml
    path = File.join(File.dirname(__FILE__), *%w[yamls single.yaml])
    resolver = YamlRefResolver.new
    yaml = resolver.resolve(path)

    assert_equal yaml, YAML.load_file(path)
  end

  def test_resolve_yaml_containing_object
    path = File.join(File.dirname(__FILE__), *%w[yamls object index.yaml])
    resolver = YamlRefResolver.new
    yaml = resolver.resolve(path)

    assert_equal yaml['paths']['/products']['post']['tags'].first, 'product'
  end
end

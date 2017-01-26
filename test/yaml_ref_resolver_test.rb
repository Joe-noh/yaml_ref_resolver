require 'test_helper'

class YamlRefResolverTest < Minitest::Test
  def test_resolve_single_yaml
    path = File.join(File.dirname(__FILE__), *%w[yamls single.yaml])
    resolver = YamlRefResolver.new
    yaml = resolver.resolve(path)

    assert_equal yaml, YAML.load_file(path)
  end

  def test_resolve_multi_yaml
    path = File.join(File.dirname(__FILE__), *%w[yamls multi index.yaml])
    resolver = YamlRefResolver.new
    yaml = resolver.resolve(path)

    assert_equal yaml['paths']['products']['post']['tags'].first, 'product'
  end
end

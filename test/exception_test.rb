require 'test_helper'

class YamlRefResolverTest < Minitest::Test
  def setup
    @resolver = YamlRefResolver.new
  end

  def test_when_file_does_not_exist
    path = File.join(File.dirname(__FILE__), *%w[yamls missing index.yaml])

    error = assert_raises YamlRefResolver::YamlNotFoundException do
      @resolver.resolve(path)
    end

    assert_match /yaml file not found/, error.message
  end

  def test_when_yaml_syntax_is_invalid
    path = File.join(File.dirname(__FILE__), *%w[yamls syntax_error.yaml])

    error = assert_raises YamlRefResolver::YamlSyntaxErrorException do
      @resolver.resolve(path)
    end

    assert error.message.include?(path)
  end
end

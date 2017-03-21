require "yaml_ref_resolver/ref"
require "yaml"

class YamlRefResolver::Yaml
  attr_reader :content

  def initialize(path:, key: '$ref')
    @filepath = path
    @key = key
    @content = YAML.load_file(path)
  end

  def refs
    find_refs(@content).flatten.compact.map do |ref|
      YamlRefResolver::Ref.new(ref, @filepath)
    end
  end

  private

  def find_refs(obj)
    return find_refs_hash(obj) if obj.is_a? Hash
    return find_refs_array(obj) if obj.is_a? Array
    return []
  end

  def find_refs_hash(hash)
    hash.inject([]) do |acc, (key, val)|
      acc << (key == @key ? val : find_refs(val))
    end
  end

  def find_refs_array(array)
    array.map {|elem| find_refs(elem) }
  end
end

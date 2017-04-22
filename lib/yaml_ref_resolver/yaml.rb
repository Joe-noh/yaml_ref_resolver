require "yaml"

class YamlRefResolver::Yaml
  attr_reader :content

  def self.load!(path:, key: '$ref')
    if File.exists?(path)
      begin
        self.new(path, YAML.load_file(path), key)
      rescue Psych::SyntaxError => e
        raise YamlRefResolver::YamlSyntaxErrorException.new(exception: e)
      end
    else
      raise YamlRefResolver::YamlNotFoundException.new(path: path)
    end
  end

  def initialize(path, content, key)
    @filepath = path
    @content = content
    @key = key
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

require "yaml_ref_resolver/version"
require "yaml"

class YamlRefResolver
  def initialize
  end

  def resolve(path)
    resolve_refs(YAML.load_file path)
  end

  private

  def resolve_refs(obj)
    return resolve_hash(obj)  if obj.is_a? Hash
    return resolve_array(obj) if obj.is_a? Array
    return obj
  end

  def resolve_hash(hash)
    hash.map {|k, v| [k, resolve_refs(v)] }.to_h
  end

  def resolve_array(array)
    array.map {|e| resolve_refs(e) }
  end
end

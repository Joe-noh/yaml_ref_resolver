require "yaml_ref_resolver/version"
require "yaml"

class YamlRefResolver
  def initialize
    @key = '$ref'
  end

  def resolve(path)
    resolve_refs(YAML.load_file(path), File.dirname(path))
  end

  private

  def resolve_refs(obj, base)
    return resolve_hash(obj, base)  if obj.is_a? Hash
    return resolve_array(obj, base) if obj.is_a? Array
    return obj
  end

  def resolve_hash(hash, base)
    resolved = hash.map do |k, v|
      if k == @key
        path, pos = v.split('#')
        ref_path = File.join(base, path)
        ref = self.resolve(ref_path)

        pos.split('/').inject(ref) {|obj, key| obj[key] }
      else
        Hash[k, resolve_refs(v, base)]
      end
    end

    resolved.inject{|h1, h2| h1.merge h2 }
  end

  def resolve_array(array, base)
    array.map {|e| resolve_refs(e, base) }
  end
end

require "yaml_ref_resolver/version"
require "yaml_ref_resolver/exceptions"
require "yaml_ref_resolver/ref"
require "yaml_ref_resolver/yaml"
require "yaml"

class YamlRefResolver
  def initialize(opts = {})
    @key = opts[:key] || '$ref'
    @map = {}
  end

  def resolve!(path)
    entry_point = File.expand_path(path)
    preload!(entry_point)

    resolve_refs(@map[entry_point].content, entry_point)
  end

  def reload!(path)
    return unless path

    backup = @map.delete(path)

    begin
      preload!(path)
    rescue => e
      @map[path] = backup
      raise e
    end
  end

  def files
    @map.keys
  end

  private

  def preload!(abs_path)
    return if @map.has_key?(abs_path)

    @map[abs_path] = Yaml.load!(path: abs_path, key: @key)
    @map[abs_path].refs.each do |ref|
      preload!(ref.abs_path)
    end
  end

  def resolve_refs(obj, referrer)
    return resolve_hash(obj, referrer)  if obj.is_a? Hash
    return resolve_array(obj, referrer) if obj.is_a? Array
    return obj
  end

  def resolve_hash(hash, referrer)
    resolved = hash.map do |key, val|
      if key == @key
        ref = Ref.new(val, referrer)

        ref_path = ref.abs_path
        target_keys = ref.target_keys

        if target_keys.size == 0
          resolve_refs(@map[ref_path].content, ref_path)
        else
          resolve_refs(dig(@map[ref_path].content, target_keys), ref_path)
        end
      else
        Hash[key, resolve_refs(val, referrer)]
      end
    end

    resolved.inject{|h1, h2| h1.merge h2 }
  end

  def resolve_array(array, referrer)
    array.map {|e| resolve_refs(e, referrer) }
  end

  def dig(hash, keys)
    keys.inject(hash) do |digged, key|
      digged[key] or return nil
    end
  end
end

require "yaml_ref_resolver/version"
require "yaml"

class YamlRefResolver
  def initialize(opts = {})
    @key = opts[:key] || '$ref'
    @yaml = {}
  end

  def resolve(path)
    entry_point = File.expand_path(path)
    preload_ref_yamls(entry_point)

    resolve_refs(@yaml[entry_point], entry_point)
  end

  def reload(path)
    @yaml.delete(path)
    preload_ref_yamls(path)
  end

  def files
    @yaml.keys
  end

  private

  def preload_ref_yamls(abs_path)
    return if @yaml.has_key?(abs_path)

    @yaml[abs_path] = YAML.load_file(abs_path)
    find_refs(@yaml[abs_path]).each do |ref_target|
      rel_path, pos = parse_ref(ref_target)
      preload_ref_yamls(File.expand_path(rel_path, File.dirname(abs_path)))
    end
  end

  def find_refs(obj)
    do_find_refs(obj).flatten.compact
  end

  def do_find_refs(obj)
    return do_find_refs_hash(obj)  if obj.is_a? Hash
    return do_find_refs_array(obj) if obj.is_a? Array
    return []
  end

  def do_find_refs_hash(hash)
    hash.inject([]) {|acc, (key, val)| acc << (key == @key ? val : do_find_refs(val)) }
  end

  def do_find_refs_array(array)
    array.map {|e| find_refs(e) }
  end

  def resolve_refs(obj, referrer)
    return resolve_hash(obj, referrer)  if obj.is_a? Hash
    return resolve_array(obj, referrer) if obj.is_a? Array
    return obj
  end

  def resolve_hash(hash, referrer)
    resolved = hash.map do |key, val|
      if key == @key
        path, pos = parse_ref(val)
        ref_path = File.expand_path(path, File.dirname(referrer))
        pos_keys = pos.split('/').reject {|s| s == "" }

        if pos_keys.size == 0
          resolve_refs(@yaml[ref_path], ref_path)
        else
          resolve_refs(@yaml[ref_path].dig(*pos_keys), ref_path)
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

  def parse_ref(ref)
    splitted = ref.split('#')

    if splitted.size == 1
      splitted << '/'
    else
      splitted
    end
  end
end

require "yaml_ref_resolver/version"
require "yaml"

class YamlRefResolver
  def initialize
  end

  def resolve(path)
    YAML.load_file(path)
  end
end

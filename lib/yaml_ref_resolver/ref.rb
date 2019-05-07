class YamlRefResolver::Ref
  def initialize(target, base_path)
    @base_dir = File.dirname(base_path)

    if target.start_with?("#")
      @target_file = base_path
      @target_level = target.sub("#", "")
    elsif !target.include?("#")
      @target_file = target
      @target_level = "/"
    else
      @target_file, @target_level = target.split("#")
    end
  end

  def abs_path
    File.expand_path(@target_file, @base_dir)
  end

  def target_keys
    @target_level.split("/").reject {|s| s == "" }
  end
end


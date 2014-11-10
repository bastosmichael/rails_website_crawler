class Flattener
  def initialize(hash)
    @hash = hash
    @result = {}
    @result_iter = {}
    @paths = hash.keys.map { |key| [key] }
  end

  def flatten(hash = @hash, old_path = [])
    hash.each do |key, value|
      current_path = old_path + [key]

      if !value.respond_to?(:keys)
        @result[current_path.join('_')] = value
      else
        flatten(value, current_path)
      end
    end

    @result
  end

  def flatten_iter
    until @paths.empty?
      path = @paths.shift
      value = @hash
      path.each { |step| value = value[step] }

      if value.respond_to?(:keys)
        value.keys.each { |key| @paths << path + [key] }
      else
        @result_iter[path.join('_')] = value
      end
    end

    @result_iter
  end

  def are_the_same?
    flatten == flatten_iter
  end
end

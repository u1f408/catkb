module CatKB
  module_function

  def stringify_query(hsh)
    return hsh if hsh.is_a?(String)

    hsh.map do |key, value|
      [value].flatten.map { |v| "#{key}=#{v}" }
    end.join('&')
  end
end

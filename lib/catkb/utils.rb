module CatKB
  PATCH_CLEANUP_OPTS = {
    :note => { strip: %i[body], },
    :container => { strip: %i[location], },
    :container_contents => { remove: %i[container], },
    :project => { strip: %i[description], },
    :part => { strip: %i[description], },
    :package_tracking => { remove: %i[track_no carrier updates updated], },
  }

  module_function

  def stringify_query(hsh)
    return hsh if hsh.is_a?(String)

    hsh.map do |key, value|
      [value].flatten.map { |v| "#{key}=#{v}" }
    end.join('&')
  end

  def cleanup_patch(ty, patch)
    %i[id barcodes within].map{ |n| patch.delete(n) }
    CatKB::PATCH_CLEANUP_OPTS[ty]&.[](:remove)&.map { |n| patch.delete(n) }
    CatKB::PATCH_CLEANUP_OPTS[ty]&.[](:strip)&.map { |n| patch[n] = patch[n]&.strip }

    patch
  end
end

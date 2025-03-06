require 'redcarpet'

module CatKB
  PATCH_CLEANUP_OPTS = {
    :note => { strip: %i[body], remove: %i[body_html], },
    :container => { strip: %i[location], },
    :container_contents => { remove: %i[container], },
    :project => { strip: %i[description], remove: %i[description_html updates], },
    :project_update => { strip: %i[description], remove: %i[project description_html], },
    :part => { strip: %i[description generic_type form_factor], remove: %i[description_html], },
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
    %i[id barcodes within images].map{ |n| patch.delete(n) }
    CatKB::PATCH_CLEANUP_OPTS[ty]&.[](:remove)&.map { |n| patch.delete(n) }
    CatKB::PATCH_CLEANUP_OPTS[ty]&.[](:strip)&.map { |n| patch[n] = patch[n]&.strip }

    patch
  end

  def render_markdown(data)
    return nil if data.nil? || data&.strip&.empty?
    @@renderer ||= Redcarpet::Markdown.new(
      Redcarpet::Render::HTML.new(no_styles: true, hard_wrap: true),
      autolink: false,
      tables: true,
      fenced_code_blocks: true,
      disable_indented_code_blocks: true,
    )

    @@renderer.render(data)
  end
end

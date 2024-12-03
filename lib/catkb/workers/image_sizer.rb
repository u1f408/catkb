require 'mini_magick'

module CatKB
  module ImageSizer
    class << self
      def storage_path
        @@storage_path ||= Pathname.new(ENV['IMAGE_STORAGE_PATH'])
        @@storage_path
      end

      def url_base
        @@url_base ||= ENV.fetch('IMAGE_URL_BASE', '/v0/imagestore/')
        @@url_base
      end
    end

    class ResizeWorker
      include Sidekiq::Job

      def perform(id, imgtemp)
        data = CatKB.db[:images].where(id: id).first
        if data.nil?
          logger.warn("no data? #{id.inspect}")
          return
        end

        ext = Pathname.new(imgtemp).extname
        patch = {
          image_fn: "#{id}_f#{ext}",
          thumb_fn: "#{id}_t#{ext}",
        }

        FileUtils.copy_file(imgtemp, (::CatKB::ImageSizer.storage_path / patch[:image_fn]).to_s)

        im = MiniMagick::Image.open(imgtemp)
        patch[:width] = im.width
        patch[:height] = im.height

        im.resize("300x300>")
        im.write((::CatKB::ImageSizer.storage_path / patch[:thumb_fn]).to_s)

        CatKB.db[:images].where(id: id).update(patch)
      end
    end
  end
end

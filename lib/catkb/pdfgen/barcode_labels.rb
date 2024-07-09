module CatKB::PdfGen
  module BarcodeLabels
    DOCUMENT_PPI = 600

    LAYOUTS = {
      "Printec E0330 (66 per page)" => {
        page_size: RcPdfLayout::PAGE_SIZE_A4,
        barcode_count: 66,
        boxes: (1..6).map do |x|
          (1..11).map do |y|
            { position: [5 + (35 * (x - 1)), 8 + (26.25 * (y - 1))], size: [25, 18]}
          end
        end.flatten,
      },
    }

    def self.document_for(layout, num_sheets)
      document = RcPdfLayout::Document.new
      (1..num_sheets).each do |n|
        page = RcPdfLayout::Object::Page.new(layout[:page_size], DOCUMENT_PPI)

        barcodes = CatKB.generate_barcode_svg_batch(layout[:barcode_count])
        barcodes.each_with_index do |bar, idx|
          svgtmp = Tempfile.new(['catkb-barcode', '.svg'])
          svgtmp.write(bar[:svg])
          svgtmp.close

          pngpath = svgtmp.path.sub(".svg", ".png")
          command = ['rsvg-convert', '-w', '1024', '-h', '1024', svgtmp.path, '-o', pngpath]
          _stdout, _stderr, status = MiniMagick::Shell.new.run(command, whiny: false)
          throw "rsvg-convert failed with status #{status}" unless status.zero?

          box = layout[:boxes][idx]
          img = RcPdfLayout::Object::Image.new(box[:position], box[:size], DOCUMENT_PPI, defer_image: true)
          img.object_image = MiniMagick::Image.open(pngpath)

          page.children << img
        end

        document.pages << page
      end

      document
    end
  end
end

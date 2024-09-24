module CatKB::PdfGen
  module BarcodeLabels
    DOCUMENT_PPI = 600

    LAYOUTS = {
      "aztec_Printec_E0330_double" => {
        page_size: RcPdfLayout::PAGE_SIZE_A4,
        barcode_format: :aztec,
        barcode_count: 66,
        barcode_dimensions: [24, 24],
        boxes: (1..6).map do |x|
          (1..11).map do |y|
            { position: [5 + (35 * (x - 1)), 8 + (26.25 * (y - 1))], size: [25, 18]}
          end
        end.flatten,
      },
      "code128_Printec_E0330" => {
        page_size: RcPdfLayout::PAGE_SIZE_A4,
        barcode_format: :code128,
        barcode_count: 33,
        barcode_dimensions: [72, 24],
        boxes: (1..3).map do |x|
          (1..11).map do |y|
            { position: [10 + (70 * (x - 1)), 8 + (26.25 * (y - 1))], size: [50, 18]}
          end
        end.flatten,
      },
    }

    def self.document_for(layout, num_sheets)
      document = RcPdfLayout::Document.new
      (1..num_sheets).each do |n|
        page = RcPdfLayout::Object::Page.new(layout[:page_size], DOCUMENT_PPI)

        barcodes = CatKB.generate_barcode_svg_batch(layout[:barcode_count], layout[:barcode_format], layout[:barcode_dimensions])
        barcodes.each_with_index do |bar, idx|
          svgtmp = Tempfile.new(['catkb-barcode', '.svg'])
          svgtmp.write(bar[:svg])
          svgtmp.close

          pngwidth = 1024
          pngheight = ((pngwidth / layout[:barcode_dimensions].first) * layout[:barcode_dimensions].last).to_i

          pngpath = svgtmp.path.sub(".svg", ".png")
          command = ['rsvg-convert', '-w', "#{pngwidth}", '-h', "#{pngheight}", svgtmp.path, '-o', pngpath]
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

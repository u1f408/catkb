require "json"

module CatKB
  def self.generate_barcode
    "%CatKB/#{generate_id(16)}/"
  end

  def self.generate_barcode_svg(data, fmt = :aztec)
    req = {encode: {request_id: "a", data: data, format: fmt}}
    resp = CatKB.binvoke(:catkb_barcoder) do |sin, sout, serr|
      sin.puts JSON.generate(req)
      sin.flush

      JSON.parse(sout.readline.chomp, symbolize_names: true)
    end

    resp[:encode][:encoded_data]
  end

  def self.generate_barcode_svg_batch(count, fmt = :aztec, dimensions = [24, 24])
    requests = (1..count).map do |n|
      ["bar#{n}", {encode: {
        request_id: "bar#{n}",
        data: CatKB.generate_barcode,
        format: fmt,
        width: dimensions.first,
        height: dimensions.last,
      }}]
    end.to_h

    responses = CatKB.binvoke(:catkb_barcoder) do |sin, sout, serr|
      requests.map do |_, req|
        sin.puts JSON.generate(req)
        sin.flush

        JSON.parse(sout.readline.chomp, symbolize_names: true)
      end
    end

    responses.map do |resp|
      {
        barcode: requests[resp[:encode][:request_id]][:encode][:data],
        svg: resp[:encode][:encoded_data],
      }
    end
  end
end

class CatKB::StoreApi
  get '/v1/search' do
    query = request.params['q']&.strip
    results = []

    barcode = CatKB.db[:barcode_pointers].where(id: query).first
    if barcode
      ptr = CatKB.db[CatKB.db_table[barcode[:ptr_type]]].where(id: barcode[:ptr_id]).first
      results << ptr.merge({ _type: barcode[:ptr_type] }) if ptr
    end

    CatKB.db_table.each do |kind, table|
      CatKB.db[table].where(Sequel.ilike(:title, "%#{query}%")).map do |entry|
        results << entry.merge({ _type: kind }) if entry
      end
    end

    json({
      query: query,
      results: results.compact,
    })
  end
end

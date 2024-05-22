class CatKB::StoreApi
  post '/v1/barcode' do
    patch = body_json()
    patch[:id] ||= CatKB.generate_barcode
    CatKB.db[:barcode_pointers] << patch

    data = CatKB.db[:barcode_pointers].where(id: patch[:id]).first
    json(data)
  end

  get '/v1/barcode' do
    barcode = request.params['id']&.strip
    data = CatKB.db[:barcode_pointers].where(id: barcode).first
    halt 404 if data.nil?
    json(data)
  end

  patch '/v1/barcode' do
    barcode = request.params['id']&.strip
    data = CatKB.db[:barcode_pointers].where(id: barcode).first
    halt 404 if data.nil?

    patch = body_json()
    patch.delete(:id)
    data.merge! patch
    CatKB.db[:barcode_pointers].where(id: barcode).update(patch)

    json(data)
  end

  delete '/v1/barcode' do
    barcode = request.params['id']&.strip
    data = CatKB.db[:barcode_pointers].where(id: barcode).first
    halt 404 if data.nil?

    CatKB.db[:barcode_pointers].where(id: barcode).delete
    204
  end
end

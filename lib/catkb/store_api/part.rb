class CatKB::StoreApi
  post '/v1/part' do
    patch = CatKB.cleanup_patch(:part, body_json())
    patch[:id] = CatKB.generate_id
    CatKB.db[:parts] << patch

    data = CatKB.db[:parts].where(id: patch[:id]).first
    json(data)
  end

  get '/v1/part/:id' do |id|
    data = CatKB.db[:parts].where(id: id).first
    halt 404 if data.nil?

    data[:barcodes] = CatKB.db[:barcode_pointers].where(ptr_type: 'part', ptr_id: id).map {|n| n[:id]}
    data[:within] = CatKB.db[:container_contents].where(ptr_type: 'part', ptr_id: id).map {|n| n[:container]}

    json(data)
  end

  patch '/v1/part/:id' do |id|
    data = CatKB.db[:parts].where(id: id).first
    halt 404 if data.nil?

    patch = CatKB.cleanup_patch(:part, body_json())
    data.merge! patch
    CatKB.db[:parts].where(id: id).update(patch)

    json(data)
  end

  delete '/v1/part/:id' do |id|
    data = CatKB.db[:parts].where(id: id).first
    halt 404 if data.nil?

    CatKB.db[:parts].where(id: id).delete
    204
  end
end

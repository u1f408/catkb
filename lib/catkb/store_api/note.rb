class CatKB::StoreApi
  post '/v1/note' do
    patch = body_json()
    %i[id barcodes within].map{ |n| patch.delete(n) }
    patch[:id] = CatKB.generate_id
    CatKB.db[:notes] << patch

    data = CatKB.db[:notes].where(id: patch[:id]).first
    json(data)
  end

  get '/v1/note/:id' do |id|
    data = CatKB.db[:notes].where(id: id).first
    halt 404 if data.nil?

    data[:barcodes] = CatKB.db[:barcode_pointers].where(ptr_type: 'project', ptr_id: id).map {|n| n[:id]}

    json(data)
  end

  patch '/v1/note/:id' do |id|
    data = CatKB.db[:notes].where(id: id).first
    halt 404 if data.nil?

    patch = body_json()
    %i[id barcodes within].map{ |n| patch.delete(n) }
    data.merge! patch
    CatKB.db[:notes].where(id: id).update(patch)

    json(data)
  end

  delete '/v1/note/:id' do |id|
    data = CatKB.db[:notes].where(id: id).first
    halt 404 if data.nil?

    CatKB.db[:notes].where(id: id).delete
    204
  end
end

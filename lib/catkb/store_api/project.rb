class CatKB::StoreApi
  post '/v1/project' do
    patch = CatKB.cleanup_patch(:project, body_json())
    patch[:id] = CatKB.generate_id
    CatKB.db[:projects] << patch

    data = CatKB.db[:projects].where(id: patch[:id]).first
    json(data)
  end

  get '/v1/project/:id' do |id|
    data = CatKB.db[:projects].where(id: id).first
    halt 404 if data.nil?

    data[:barcodes] = CatKB.db[:barcode_pointers].where(ptr_type: 'project', ptr_id: id).map {|n| n[:id]}
    data[:within] = CatKB.db[:container_contents].where(ptr_type: 'project', ptr_id: id).map {|n| n[:container]}

    json(data)
  end

  patch '/v1/project/:id' do |id|
    data = CatKB.db[:projects].where(id: id).first
    halt 404 if data.nil?

    patch = CatKB.cleanup_patch(:project, body_json())
    data.merge! patch
    CatKB.db[:projects].where(id: id).update(patch)

    json(data)
  end

  delete '/v1/project/:id' do |id|
    data = CatKB.db[:projects].where(id: id).first
    halt 404 if data.nil?

    CatKB.db[:projects].where(id: id).delete
    204
  end
end

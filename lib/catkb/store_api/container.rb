class CatKB::StoreApi
  post '/v1/container' do
    patch = CatKB.cleanup_patch(:container, body_json())
    patch[:id] = CatKB.generate_id
    CatKB.db[:containers] << patch

    data = CatKB.db[:containers].where(id: patch[:id]).first
    json(data)
  end

  get '/v1/container/:id' do |id|
    data = CatKB.db[:containers].where(id: id).first
    halt 404 if data.nil?

    data[:barcodes] = CatKB.db[:barcode_pointers].where(ptr_type: 'container', ptr_id: id).map {|n| n[:id]}
    data[:within] = CatKB.db[:container_contents].where(ptr_type: 'container', ptr_id: id).map do |n|
      { id: n[:container], child: n[:id] }
    end

    if request.params['with_children']
      data[:children] = CatKB.db[:container_contents].where(container: id).map do |ptr|
        ch = CatKB.db[CatKB.db_table[ptr[:ptr_type]]].where(id: ptr[:ptr_id]).first
        ch[:_type] = ptr[:ptr_type]
        [ptr[:id], ch]
      end.to_h
    end

    json(data)
  end

  patch '/v1/container/:id' do |id|
    data = CatKB.db[:containers].where(id: id).first
    halt 404 if data.nil?

    patch = CatKB.cleanup_patch(:container, body_json())
    data.merge! patch
    CatKB.db[:containers].where(id: id).update(patch)

    json(data)
  end

  delete '/v1/container/:id' do |id|
    data = CatKB.db[:containers].where(id: id).first
    halt 404 if data.nil?

    CatKB.db[:containers].where(id: id).delete
    204
  end

  get '/v1/container/:id/children' do |id|
    ctr = CatKB.db[:containers].where(id: id).first
    halt 404 if ctr.nil?

    data = CatKB.db[:container_contents].where(container: id).all
    json(data)
  end

  post '/v1/container/:id/children' do |id|
    ctr = CatKB.db[:containers].where(id: id).first
    halt 404 if ctr.nil?

    patch = CatKB.cleanup_patch(:container_contents, body_json())
    patch[:id] = CatKB.generate_id
    patch[:container] = ctr[:id]
    CatKB.db[:container_contents] << patch

    data = CatKB.db[:container_contents].where(id: patch[:id]).first
    json(data)
  end

  patch '/v1/container/:id/children/:cid' do |id, cid|
    ctr = CatKB.db[:containers].where(id: id).first
    halt 404 if ctr.nil?
    data = CatKB.db[:container_contents].where(container: id, id: cid).first
    halt 404 if data.nil?

    patch = CatKB.cleanup_patch(:container_contents, body_json())
    data.merge! patch
    CatKB.db[:container_contents].where(id: cid).update(patch)

    json(data)
  end

  delete '/v1/container/:id/children/:cid' do |id, cid|
    ctr = CatKB.db[:containers].where(id: id).first
    halt 404 if ctr.nil?
    data = CatKB.db[:container_contents].where(container: id, id: cid).first
    halt 404 if data.nil?

    CatKB.db[:container_contents].where(id: cid).delete
    204
  end
end

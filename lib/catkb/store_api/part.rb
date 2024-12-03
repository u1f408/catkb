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

    data[:description_html] = CatKB.render_markdown(data[:description])
    data[:barcodes] = CatKB.db[:barcode_pointers].where(ptr_type: 'part', ptr_id: id).map {|n| n[:id]}
    data[:within] = CatKB.db[:container_contents].where(ptr_type: 'part', ptr_id: id).map do |n|
      { id: n[:container], child: n[:id] }
    end
    data[:images] = CatKB.db[:image_links].where(ptr_type: 'part', ptr_id: id).map do |n|
      img = CatKB.db[:images].where(id: n[:image]).first
      {
        id: img[:id],
        child: n[:id],
        image_url: CatKB::ImageSizer.url_base + img[:image_fn],
        thumb_url: CatKB::ImageSizer.url_base + img[:thumb_fn],
      }
    end

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

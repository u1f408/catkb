class CatKB::StoreApi
  post '/v1/image' do
    imgtemp = params[:image]&.[](:tempfile)&.path
    orig_fn = params[:image]&.[](:filename)
    halt 400 unless imgtemp && orig_fn

    new_id = CatKB.generate_id
    CatKB.db[:images] << {
      id: new_id,
      original_name: orig_fn,
      original_size_bytes: File.stat(imgtemp).size,
    }

    CatKB::ImageSizer::ResizeWorker.perform_sync(new_id, imgtemp)

    data = CatKB.db[:images].where(id: new_id).first
    data[:image_url] = CatKB::ImageSizer.url_base + data[:image_fn]
    data[:thumb_url] = CatKB::ImageSizer.url_base + data[:thumb_fn]

    json(data)
  end

  get '/v1/image/:id' do |id|
    data = CatKB.db[:images].where(id: id).first
    halt 404 if data.nil?

    data[:image_url] = CatKB::ImageSizer.url_base + data[:image_fn]
    data[:thumb_url] = CatKB::ImageSizer.url_base + data[:thumb_fn]

    json(data)
  end

  delete '/v1/image/:id' do |id|
    data = CatKB.db[:images].where(id: id).first
    halt 404 if data.nil?

    CatKB.db[:images].where(id: id).delete
    204
  end

  get '/v1/image/:id/links' do |id|
    img = CatKB.db[:images].where(id: id).first
    halt 404 if img.nil?

    data = CatKB.db[:image_links].where(image: id).all
    json(data)
  end

  post '/v1/image/:id/links' do |id|
    img = CatKB.db[:images].where(id: id).first
    halt 404 if img.nil?

    patch = CatKB.cleanup_patch(:image_links, body_json())
    patch[:id] = CatKB.generate_id
    patch[:image] = img[:id]
    CatKB.db[:image_links] << patch

    data = CatKB.db[:image_links].where(id: patch[:id]).first
    json(data)
  end

  patch '/v1/image/:id/links/:cid' do |id, cid|
    img = CatKB.db[:images].where(id: id).first
    halt 404 if img.nil?
    data = CatKB.db[:image_links].where(image: id, id: cid).first
    halt 404 if data.nil?

    patch = CatKB.cleanup_patch(:image_links, body_json())
    data.merge! patch
    CatKB.db[:image_links].where(id: cid).update(patch)

    json(data)
  end

  delete '/v1/image/:id/links/:cid' do |id, cid|
    img = CatKB.db[:images].where(id: id).first
    halt 404 if img.nil?
    data = CatKB.db[:image_links].where(image: id, id: cid).first
    halt 404 if data.nil?

    CatKB.db[:image_links].where(id: cid).delete
    204
  end
end

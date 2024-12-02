class CatKB::StoreApi
  post '/v1/note' do
    patch = CatKB.cleanup_patch(:note, body_json())
    patch[:id] = CatKB.generate_id
    CatKB.db[:notes] << patch

    data = CatKB.db[:notes].where(id: patch[:id]).first
    json(data)
  end

  get '/v1/note/:id' do |id|
    data = CatKB.db[:notes].where(id: id).first
    halt 404 if data.nil?

    data[:body_html] = CatKB.render_markdown(data[:body])

    json(data)
  end

  patch '/v1/note/:id' do |id|
    data = CatKB.db[:notes].where(id: id).first
    halt 404 if data.nil?

    patch = CatKB.cleanup_patch(:note, body_json())
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

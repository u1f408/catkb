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

    data[:description_html] = CatKB.render_markdown(data[:description])
    data[:barcodes] = CatKB.db[:barcode_pointers].where(ptr_type: 'project', ptr_id: id).map {|n| n[:id]}
    data[:within] = CatKB.db[:container_contents].where(ptr_type: 'project', ptr_id: id).map do |n|
      { id: n[:container], child: n[:id] }
    end
    data[:images] = CatKB.db[:image_links].where(ptr_type: 'project', ptr_id: id).map do |n|
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

  get '/v1/project/:id/+updates' do |id|
    data = CatKB.db[:projects].where(id: id).first
    halt 404 if data.nil?

    updates = CatKB.db[:project_updates].where(project: id).order(Sequel.desc(:created)).map do |upd|
      upd[:description_html] = CatKB.render_markdown(upd[:description])
      upd[:images] = CatKB.db[:image_links].where(ptr_type: 'project_update', ptr_id: upd[:id]).map do |n|
        img = CatKB.db[:images].where(id: n[:image]).first
        {
          id: img[:id],
          child: n[:id],
          image_url: CatKB::ImageSizer.url_base + img[:image_fn],
          thumb_url: CatKB::ImageSizer.url_base + img[:thumb_fn],
        }
      end

      upd
    end

    json(updates)
  end

  get '/v1/project/:proj_id/update/:upd_id' do |proj_id, upd_id|
    data = CatKB.db[:projects].where(id: proj_id).first
    halt 404 if data.nil?
    upd = CatKB.db[:project_updates].where(id: upd_id, project: proj_id).first
    halt 404 if upd.nil?

    upd[:description_html] = CatKB.render_markdown(upd[:description])
    upd[:images] = CatKB.db[:image_links].where(ptr_type: 'project_update', ptr_id: upd[:id]).map do |n|
      img = CatKB.db[:images].where(id: n[:image]).first
      {
        id: img[:id],
        child: n[:id],
        image_url: CatKB::ImageSizer.url_base + img[:image_fn],
        thumb_url: CatKB::ImageSizer.url_base + img[:thumb_fn],
      }
    end

    json(upd)
  end

  post '/v1/project/:id/update' do |id|
    data = CatKB.db[:projects].where(id: id).first
    halt 404 if data.nil?

    patch = CatKB.cleanup_patch(:project, body_json())
    patch[:id] = CatKB.generate_id
    patch[:project] = id
    CatKB.db[:project_updates] << patch

    upd = CatKB.db[:project_updates].where(id: patch[:id], project: id).first
    json(upd)
  end

  patch '/v1/project/:proj_id/update/:upd_id' do |proj_id, upd_id|
    data = CatKB.db[:projects].where(id: proj_id).first
    halt 404 if data.nil?
    upd = CatKB.db[:project_updates].where(id: upd_id, project: proj_id).first
    halt 404 if upd.nil?

    patch = CatKB.cleanup_patch(:project_update, body_json())
    upd.merge! patch
    patch[:updated] = Sequel.lit('NOW()::timestamp')
    CatKB.db[:project_updates].where(id: upd_id).update(patch)

    json(upd)
  end

  delete '/v1/project/:proj_id/update/:upd_id' do |proj_id, upd_id|
    data = CatKB.db[:projects].where(id: proj_id).first
    halt 404 if data.nil?
    upd = CatKB.db[:project_updates].where(id: upd_id, project: proj_id).first
    halt 404 if upd.nil?

    CatKB.db[:project_updates].where(id: upd_id).delete
    204
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

class CatKB::StoreApi
  get '/v1/package_tracking/+waiting' do
    limit = request.params['limit']&.to_i || 10

    undelivered = CatKB.db[:package_tracking].where(completed: false, marked: nil).order(Sequel.desc(:updated)).limit(limit).all
    undelivered.map! do |p|
      p[:latest_update] = CatKB.db[:package_tracking_updates].where(track_no: p[:track_no]).order(Sequel.desc(:updated)).first
      p
    end

    unmarked = CatKB.db[:package_tracking].where(completed: true, marked: nil).order(Sequel.desc(:updated)).limit(limit).all
    unmarked.map! do |p|
      p[:latest_update] = CatKB.db[:package_tracking_updates].where(track_no: p[:track_no]).order(Sequel.desc(:updated)).first
      p
    end

    json({
      undelivered: undelivered,
      unmarked: unmarked,
    })
  end

  post '/v1/package_tracking' do
    patch = body_json()
    patch[:track_no].strip!

    data = CatKB.db[:package_tracking].where(track_no: patch[:track_no]).first
    next halt 400 if data

    CatKB.db[:package_tracking] << patch
    CatKB::PackageTrackingUpdateSingleWorker.perform_sync(patch[:track_no])

    data = CatKB.db[:package_tracking].where(track_no: patch[:track_no]).first
    json(data)
  end

  get '/v1/package_tracking/:tn' do |tn|
    data = CatKB.db[:package_tracking].where(track_no: tn).first
    next halt 404 unless data
    data[:updates] = CatKB.db[:package_tracking_updates].where(track_no: tn).order(Sequel.desc(:updated)).all
    json(data)
  end

  post '/v1/package_tracking/:tn/mark' do |tn|
    data = CatKB.db[:package_tracking].where(track_no: tn).first
    next halt 404 unless data

    CatKB.db[:package_tracking].where(track_no: tn).update(marked: Sequel.lit('NOW()'))
    json(CatKB.db[:package_tracking].where(track_no: tn).first)
  end

  patch '/v1/package_tracking/:tn' do |tn|
    data = CatKB.db[:package_tracking].where(track_no: tn).first
    next halt 404 unless data

    patch = CatKB.cleanup_patch(:package_tracking, body_json())
    data.merge! patch
    CatKB.db[:package_tracking].where(track_no: tn).update(patch)

    json(data)
  end

  delete '/v1/package_tracking/:tn' do |tn|
    data = CatKB.db[:package_tracking].where(track_no: tn).first
    next halt 404 unless data

    CatKB.db[:package_tracking].where(track_no: tn).delete
    204
  end
end

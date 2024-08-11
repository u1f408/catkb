class CatKB::StoreApi
  get '/v1/serial_lookup/apple/+latest' do
    limit = request.params['limit']&.to_i || 10
    list = CatKB.db[:serial_lookup_apple].order(Sequel.desc(:updated)).limit(limit).all
    json({latest: list})
  end

  get '/v1/serial_lookup/apple/:sn' do |sn|
    data = CatKB.db[:serial_lookup_apple].where(sn: sn).first
    next halt 404 unless data
    json(data)
  end

  post '/v1/serial_lookup/apple/:sn' do |sn|
    data = CatKB.db[:serial_lookup_apple].where(sn: sn).first
    force_update = data.nil? || !(request.params['force_refresh'].nil?())
    next json(data) unless force_update

    CatKB::SerialLookup::SerialLookupAppleWorker.perform_sync(sn)
    data = CatKB.db[:serial_lookup_apple].where(sn: sn).first
    json(data)
  end
end

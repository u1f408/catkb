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

    req_body = JSON.generate({
      primary: {
        identifier: sn,
        type: 'apple_serial',
      },
    })

    resp = HTTParty.post(
      'https://di-api.reincubate.com/v2/lookup/',
      body: req_body,
      headers: { 'Content-Type' => 'application/json' }
    ).parsed_response

    new_data = {
      model_identifier: resp['hardware']['identifier'],
      model_family: resp['specification']['family'].first&.[]('name'),
      marketing_name: resp['marketing']['names'].first,
      configuration_code: resp['specification']['configuration_code']&.first&.[]('code'),
    }

    next halt 404 if new_data.values.all?(&:nil?)
    new_data[:sn] = sn

    if data.nil?
      CatKB.db[:serial_lookup_apple] << new_data
    else
      new_data.delete(:sn)
      CatKB.db[:serial_lookup_apple].where(sn: sn).update(new_data)
    end

    data = CatKB.db[:serial_lookup_apple].where(sn: sn).first
    json(data)
  end
end

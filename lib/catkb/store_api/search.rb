class CatKB::StoreApi
  get '/v1/search' do
    query = request.params['q']&.strip
    results = CatKB.db_table.map do |kind, table|
      CatKB.db[table].where(Sequel.ilike(:title, "%#{query}%")).map do |entry|
        entry.merge({ _type: kind })
      end
    end.flatten.compact

    json({
      query: query,
      results: results,
    })
  end
end

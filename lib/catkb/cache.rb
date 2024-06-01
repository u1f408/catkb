require 'redis'

module CatKB
  @cache = nil

  def self.cache
    @cache ||= self._cache_connect
  end

  private

  def self._cache_connect
    db = Redis.new(url: ENV['REDIS_URL'])
    db
  end
end

require 'pathname'
require 'securerandom'

module CatKB
  ROOT_DIR = Pathname.new File.expand_path('../..', __FILE__)
  BASE32_CROCKFORD_TABLE = '0123456789abcdefghjkmnpqrstvwxyz'.freeze

  def self.generate_id(length = 20)
    SecureRandom.random_bytes(length).bytes.to_a.map do |b|
      CatKB::BASE32_CROCKFORD_TABLE[b % 32]
    end.join
  end
end

require_relative 'catkb/version'
require_relative 'catkb/database'
require_relative 'catkb/cache'
require_relative 'catkb/binvoke'
require_relative 'catkb/barcode'

require 'base32'
require 'pathname'

module CatKB
  ROOT_DIR = Pathname.new File.expand_path('../..', __FILE__)

  BASE32_CROCKFORD_TABLE = '0123456789ABCDEFGHJKMNPQRSTVWXYZ'.freeze
  Base32.table = CatKB::BASE32_CROCKFORD_TABLE

  def self.generate_id(length = 20)
    Base32.random_base32(length, false).downcase
  end
end

require_relative 'catkb/version'
require_relative 'catkb/database'
require_relative 'catkb/cache'
require_relative 'catkb/binvoke'
require_relative 'catkb/barcode'

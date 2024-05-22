require 'dotenv/load'
require_relative 'lib/catkb'
require_relative 'lib/catkb/store_api'

run CatKB::StoreApi

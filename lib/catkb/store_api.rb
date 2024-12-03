require 'sinatra/base'
require 'httparty'
require 'json'

module CatKB
  class StoreApi < Sinatra::Base
    configure do
      disable :sessions
    end

    before do
      allowedMethods = 'GET, HEAD, OPTIONS, POST, PATCH, DELETE'
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Methods'] = allowedMethods
      headers['Access-Control-Allow-Headers'] = 'Content-Type, User-Agent'

      if request.options?
        headers['Allow'] = allowedMethods
        halt 204
      end
    end

    get '/' do
      content_type 'text/html'
      "<p>this is the CatKB StoreApi</p><p>you probably shouldn't be here...</p>"
    end

    helpers do
      def json(data)
        content_type 'application/json'
        JSON.generate(data)
      end

      def body_json()
        JSON.parse(request.body.read.chomp, symbolize_names: true)
      end
    end
  end
end

require_relative 'store_api/search'
require_relative 'store_api/image'
require_relative 'store_api/barcode'
require_relative 'store_api/container'
require_relative 'store_api/project'
require_relative 'store_api/part'
require_relative 'store_api/note'
require_relative 'store_api/serial_lookup'
require_relative 'store_api/package_tracking'

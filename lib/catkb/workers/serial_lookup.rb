require 'httparty'

module CatKB
  module SerialLookup
    class SerialLookupAppleWorker
      include Sidekiq::Job

      def perform(sn)
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

        if new_data.values.all?(&:nil?)
          logger.warn "all-nil response for Apple SN #{sn}, bailing!"
          return
        end

        if CatKB.db[:serial_lookup_apple].where(sn: sn).count > 0
          CatKB.db[:serial_lookup_apple].where(sn: sn).update(new_data)
          return
        end

        new_data[:sn] = sn
        CatKB.db[:serial_lookup_apple] << new_data
      end
    end
  end
end

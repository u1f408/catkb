require 'httparty'
require 'tzinfo'

module CatKB
  module PackageTracking
    UA_GENERIC = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36'.freeze
    module_function

    def guess_carrier(track_no)
      return 'nzpost' if /^[A-Z]{2}[0-9]{9}NZ$/.match?(track_no)
      nil
    end

    def fetch_aramexnz(track_no)
      track_no.upcase!

      query = {
        callback: '',
        dataFormat: 'json',
        LabelNo: track_no,
      }

      response = HTTParty.get(
        'https://www.aramex.co.nz/tracking-api/?' + CatKB.stringify_query(query),
        headers: {
          "User-Agent" => UA_GENERIC,
          "Accept" => "application/json, text/javascript, */*; q=0.01",
        },
        format: :plain,
      )

      parsed = JSON.parse(response, symbolize_names: true)
      return nil unless parsed[:error].nil?

      tz = TZInfo::Timezone.get('Pacific/Auckland')
      scans = parsed[:result][:Scans].map do |sc|
        ts = tz.local_to_utc(DateTime.strptime(sc[:RealDateTime], '%Y-%m-%d %H:%M:%S').to_time)

        if sc[:Type] == 'P'
          status = 'picked_up' 
        elsif sc[:Type] == 'T' && sc[:Status] == 'ONB'
          status = 'on_board'
        elsif sc[:Type] == 'T'
          status = 'in_transit'
        elsif sc[:Type] == 'D'
          status = 'delivered'
        else
          status = 'unknown'
        end

        {
          status: status,
          description: sc[:Description],
          updated: ts,
        }
      end.sort{ |a, b| a[:updated] <=> b[:updated] }

      {
        carrier: 'aramexnz',
        track_no: track_no,
        updates: scans,
      }
    end

    def fetch_nzpost(track_no)
      track_no.upcase!

      query = { tracking_reference: track_no, }
      response = HTTParty.get(
        'https://tools.nzpost.co.nz/tracking/api/parceltrack/parcels?' + CatKB.stringify_query(query),
        headers: {
          "User-Agent" => UA_GENERIC,
          "Accept" => "application/json",
        },
        format: :plain,
      )

      parsed = JSON.parse(response, symbolize_names: true)
      return nil unless parsed[:success]

      ours = parsed[:results].filter {|x| x[:tracking_reference] == track_no }.first
      return nil if ours[:errors]&.count

      scans = ours[:tracking_events].map do |sc|
        ts = Time.parse(sc[:date_time])

        if sc[:edifact_code] == '997'
          status = 'tracking_number_allocated'
        elsif sc[:edifact_code] == '32' || [ "With courier for delivery", ].include?(sc[:status])
          status = 'on_board'
        elsif sc[:edifact_code] == '22' || [ "Delivered", ].include?(sc[:status])
          status = 'delivered'
        elsif [ "Handover for arrival processing", "International arrival", ].include?(sc[:status])
          status = 'international_arrival'
        elsif [ "Collected from sender", ].include?(sc[:status])
          status = 'picked_up'
        elsif [ "In transit", "In transit to local depot", "Processed at depot", ].include?(sc[:status])
          status = 'in_transit'
        else
          status = 'unknown'
        end

        {
          status: status,
          description: "#{sc[:status]} (#{sc[:edifact_code]})",
          updated: ts,
        }
      end.sort{ |a, b| a[:updated] <=> b[:updated] }

      {
        carrier: 'nzpost',
        track_no: track_no,
        updates: scans,
      }
    end
  end

  class PackageTrackingUpdateSingleWorker
    include Sidekiq::Job

    def perform(track_no)
      metadata = CatKB.db[:package_tracking].where(track_no: track_no).first
      if metadata.nil?
        logger.warn "no entry in DB for track_no #{track_no.inspect}, bailing!"
        return
      end

      latest = CatKB::PackageTracking.send("fetch_#{metadata[:carrier]}".to_sym, track_no)
      unless latest
        logger.warn "fetch_#{metadata[:carrier]} for track_no #{track_no.inspect} returned #{latest.inspect}, bailing!"
        return
      end

      latest[:updates].each do |sc|
        sc = sc.merge({ track_no: track_no, })
        unless CatKB.db[:package_tracking_updates].where(sc).count > 0
          CatKB.db[:package_tracking_updates] << sc
        end
      end

      completed = latest[:updates].map{ |x| x[:status] == 'delivered' }.any?
      CatKB.db[:package_tracking].where(track_no: track_no).update({
        completed: completed,
        updated: Sequel.lit('NOW()'),
      })
    end
  end

  class PackageTrackingUpdateNonCompletedWorker
    include Sidekiq::Job

    def perform
      CatKB.db[:package_tracking].where(completed: false).each do |p|
        CatKB::PackageTrackingUpdateSingleWorker.perform_async(p[:track_no])
      end
    end
  end
end

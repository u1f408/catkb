module CatKB
  module Pushover
    class << self
      def send_notification(message, title = nil)
        return nil if app_token.nil? || user_keys.nil?

        data = {
          token: app_token,
          user: user_keys.join(','),
          message: message,
        }

        data[:title] = title unless title.nil?

        HTTParty.post(
          'https://api.pushover.net/1/messages.json',
          body: JSON.generate(data),
          headers: { 'Content-Type' => 'application/json' }
        ).parsed_response
      end

      private

      def app_token
        unless defined?(@token) && @token.is_a?(String)
          @token = ENV.fetch("PUSHOVER_APP_TOKEN", nil)
        end
        @token
      end

      def user_keys
        unless defined?(@user_keys) && @user_keys.is_a?(Array)
          @user_keys = ENV.fetch("PUSHOVER_USER_KEYS", nil)&.split(',')&.map(&:strip)
        end
        @user_keys
      end
    end
  end
end

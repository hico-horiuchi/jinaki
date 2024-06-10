require 'base64'

module Jinaki
  module Helper
    module Wakatime
      private

      def wakatime_client
        @wakatime_client ||= Faraday.new(
          url: 'https://api.wakatime.com',
          headers: {
            'Authorization' => "Basic #{Base64.strict_encode64(ENV.fetch('WAKATIME_API_KEY', nil))}",
            'Content-Type' => 'application/json'
          }
        )
      end
    end
  end
end

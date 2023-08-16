module Jinaki
  module Helper
    module Esa
      ESA_ICON = 'https://assets.esa.io/assets/apple-touch-icon-133ed3152feb59153eeaf8849cf1cad0b4447e95f359ce7f621f75fad49d1512.png'.freeze
      ESA_COLOR = '#0a9b94'.freeze

      private

      def esa_client
        @esa_client ||= ::Esa::Client.new(access_token: ENV.fetch('ESA_ACCESS_TOKEN', nil), current_team: ENV.fetch('ESA_CURRENT_TEAM', nil))
      end
    end
  end
end

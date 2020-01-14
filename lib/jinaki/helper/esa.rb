module Jinaki
  module Helper
    module Esa
      ESA_ICON = 'https://img.esa.io/uploads/production/attachments/105/2019/05/14/2/291fcf8e-866e-4976-974a-81130e3966d7.png'.freeze
      ESA_COLOR = '#0a9b94'.freeze

      def esa_client
        @esa_client ||= ::Esa::Client.new(access_token: ENV['ESA_ACCESS_TOKEN'], current_team: ENV['ESA_CURRENT_TEAM'])
      end

      def shared?(post)
        !post.body['sharing_urls'].nil?
      end

      def wip?(post)
        post.body['wip']
      end
    end
  end
end

module Jinaki
  module Helper
    module Esa
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

module Jinaki
  module Helper
    module Esa
      def esa_client
        @client ||= Esa::Client.new(access_token: ENV['ESA_ACCESS_TOKEN'], current_team: ENV['ESA_CURRENT_TEAM'])
      end

      def signated?(request)
        return false unless request.env['HTTP_X_ESA_SIGNATURE']

        payload = request.body.read
        hexdigest = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), ENV['ESA_SECRET_TOKEN'], payload)
        signature = request.env['HTTP_X_ESA_SIGNATURE'].gsub(/^sha256=/, '')

        Rack::Utils.secure_compare(hexdigest, signature)
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

module Jinaki
  module Route
    module Esa
      def self.registered(app)
        endpoint = Endpoint::Esa.new

        app.post '/esa/events' do
          endpoint.post_events(request)
          status 204
        rescue Error::Esa::UnsignatedError
          status 401
        end
      end
    end
  end
end

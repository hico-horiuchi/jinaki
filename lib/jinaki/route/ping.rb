module Jinaki
  module Route
    module Ping
      def self.registered(app)
        controller = Controller::Ping.new

        app.get '/ping' do
          controller.get(request)

          status(200)
        end
      end
    end
  end
end

module Jinaki
  module Route
    module Esa
      def self.registered(app)
        controller = Controller::Esa.new

        app.post '/esa/events' do
          controller.post_events(request)
          status 204
        end
      end
    end
  end
end

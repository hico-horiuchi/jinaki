module Jinaki
  module App
    class Esa < Sinatra::Base
      configure :production do
        use Rack::EsaWebhooks, secret: ENV.fetch('ESA_SECRET_TOKEN', nil)
      end

      register Route::Esa
    end
  end
end

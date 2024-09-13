module Jinaki
  class App < Sinatra::Base
    configure :production do
      use Rack::EsaWebhooks, secret: ENV.fetch('ESA_SECRET_TOKEN', nil)
    end

    register Route::Esa
    register Route::Ping
  end
end

module Jinaki
  class App < Sinatra::Base
    configure :production do
      use Rack::EsaWebhooks, secret: ENV['ESA_SECRET_TOKEN']
    end

    register Route::Esa
  end
end

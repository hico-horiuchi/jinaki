module Jinaki
  class App < Sinatra::Base
    use Rack::EsaWebhooks, secret: ENV['ESA_SECRET_TOKEN']
    register Route::Esa
  end
end

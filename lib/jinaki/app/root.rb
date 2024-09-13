module Jinaki
  module App
    class Root < Sinatra::Base
      register Route::Ping
    end
  end
end

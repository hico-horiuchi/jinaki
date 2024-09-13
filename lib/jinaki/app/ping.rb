module Jinaki
  module App
    class Ping < Sinatra::Base
      register Route::Ping
    end
  end
end

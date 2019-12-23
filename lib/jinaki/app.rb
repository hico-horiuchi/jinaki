module Jinaki
  class App < Sinatra::Base
    register Route::Esa
  end
end

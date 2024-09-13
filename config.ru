require File.expand_path('lib/jinaki', __dir__)

run Rack::URLMap.new({
                       '/' => Jinaki::App::Root,
                       '/esa' => Jinaki::App::Esa
                     })

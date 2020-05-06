Dir["#{__dir__}/model/*.rb"].sort.each { |f| require f }

module Jinaki
  module Model
  end
end

Dir["#{__dir__}/endpoint/*.rb"].sort.each { |f| require f }

module Jinaki
  module Endpoint
  end
end

Dir["#{__dir__}/route/*.rb"].sort.each { |f| require f }

module Jinaki
  module Route
  end
end

Dir["#{__dir__}/error/*.rb"].sort.each { |f| require f }

module Jinaki
  module Error
  end
end

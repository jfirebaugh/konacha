module Matcha
  class Server
    def self.start
      Rack::Server.start(:app => Matcha.application, :Port => Matcha.port, :AccessLog => [])
    end
  end
end

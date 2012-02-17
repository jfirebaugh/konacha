module Konacha
  class Server
    def self.start
      Rack::Server.start(:app => Konacha.application, :Port => Konacha.port, :AccessLog => [])
    end
  end
end

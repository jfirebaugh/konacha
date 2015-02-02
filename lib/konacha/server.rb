module Konacha
  class Server
    def self.start
      Rack::Server.start(:app => Konacha.application, :Host => Konacha.host, :Port => Konacha.port, :AccessLog => [])
    end
  end
end

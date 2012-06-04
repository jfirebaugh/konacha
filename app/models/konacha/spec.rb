module Konacha
  class Spec
    class NotFound < StandardError
    end

    def self.all
      paths = Konacha.spec_paths
      if ENV["SPEC"]
        paths =  ENV["SPEC"].split(",")
      end
      paths.map {|path| new(path)}
    end

    def self.find(path)
      all.select { |s| s.path.starts_with?(path) }.presence or raise NotFound
    end

    attr_accessor :path

    def initialize(path)
      @path = path
    end

    def url
      "/#{asset_name}"
    end

    def asset_name
      path.sub(/(\.js|\.coffee).*/, '')
    end
  end
end

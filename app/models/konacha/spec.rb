module Konacha
  class Spec
    def self.all
      Konacha.spec_paths.map { |path| new(path) }
    end

    def self.find(asset_name)
      all.find { |spec| spec.asset_name == asset_name }
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

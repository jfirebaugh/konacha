module Konacha
  class Spec
    class NotFound < StandardError
    end

    def self.all(path = nil)
      paths = Konacha.spec_paths
      paths = ENV["SPEC"].split(",") if ENV["SPEC"]
      paths = paths.map { |p| new(p) }
      if path.present?
        paths = paths.select { |s| s.path.starts_with?(path) }.presence or raise NotFound
      end
      paths
    end

    def self.find_by_name(name)
      all.find { |s| s.asset_name == name } or raise NotFound
    end

    attr_accessor :path

    def initialize(path)
      @path = path
    end

    def asset_name
      path.sub(/(\.js|\.coffee).*/, '')
    end
  end
end

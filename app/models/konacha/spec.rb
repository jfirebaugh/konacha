module Konacha
  class Spec
    class NotFound < StandardError
    end

    def self.all(path = nil, grep = nil)
      paths = Konacha.spec_paths
      paths = ENV["SPEC"].split(",") if ENV["SPEC"]
      paths = paths.map { |p| new(p) }
      if path.present?
        paths = paths.select { |s| s.path.starts_with?(path) }
      end
      if Konacha.iframe_economy and grep.present?
        paths = paths.select do |s|
          s.grep_match(grep)
        end
      end
      paths.presence or raise NotFound
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

    def grep_match(grep)
      asset = (asset_name.split("/").last.underscore + ".").sub(Konacha.spec_matcher, "")
      grep.gsub(/\s/, "_").downcase.starts_with? asset
    end
  end
end

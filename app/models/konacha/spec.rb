module Konacha
  class Spec
    def self.all
      Konacha.spec_paths.map { |path| new(path) }
    end

    def self.find(basename)
      all.find { |spec| spec.basename == basename }
    end

    attr_accessor :path

    def initialize(path)
      @path = path
    end

    def url
      "/#{basename}"
    end

    def basename
      path[/.*(?=\.js.*$)/]
    end
  end
end

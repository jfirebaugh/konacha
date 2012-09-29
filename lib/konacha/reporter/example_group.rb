require "konacha/reporter/metadata"

# The ExampleGroup class mimics the public interface of RSpec::Core::ExampleGroup.

module Konacha
  class Reporter
    class ExampleGroup
      attr_reader :metadata, :parent

      def initialize(data, parent)
        @metadata = Metadata.new(data)
        @parent = parent
      end

      delegate :full_description, :description, :file_path, :described_class, :to => :metadata

      alias_method :display_name, :description

      def parent_groups
        ancestor = parent
        groups = []
        while ancestor
          groups << ancestor
          ancestor = ancestor.parent
        end

        groups
      end

      alias_method :ancestors, :parent_groups

      def update_metadata(data)
        metadata.update(data)
      end
    end
  end
end

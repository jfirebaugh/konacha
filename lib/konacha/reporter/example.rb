require "konacha/reporter/metadata"

# The Example class mimics the public interface of RSpec::Core::Example.

module Konacha
  class Reporter
    class Example
      attr_reader :metadata, :parent

      def initialize(data, parent)
        @metadata = Metadata.new(data)
        @parent = parent
        if parent
          update_metadata(example_group: parent.metadata)
        end
      end

      delegate :full_description, :description, :location, :file_path, :line_number, :pending, :pending_message, :exception, :execution_result, :to => :metadata

      alias_method :pending?, :pending
      alias_method :options, :metadata
      alias_method :example_group, :parent

      def passed?
        execution_result[:status] == "passed"
      end

      def failed?
        execution_result[:status] == "failed"
      end

      def update_metadata(data)
        metadata.update(data)
      end
    end
  end
end

# The Metadata class mimics the public interface of RSpec::Core::Metadata.

module Konacha
  class Reporter
    class SpecException < Exception
      def pending_fixed?
        false
      end
    end

    class Metadata
      attr_reader :data

      def initialize(data)
        @data = data
      end

      def [](key)
        respond_to?(key) ? send(key) : data[key]
      end

      def update(data)
        @data.merge!(data)
      end

      def file_path
        data['path']
      end

      alias_method :location, :file_path

      def line_number
        STDERR.puts "line_number not implemented" if Konacha.config.verbose
        nil
      end

      def execution_result
        @execution_result ||= {
          :status      => data['status'],
          :started_at  => nil,
          :finished_at => nil,
          :run_time    => data['duration'],
          :exception   => exception
        }
      end

      def exception
        return unless data['status'] == "failed"

        @exception ||= begin
          e = Reporter::SpecException.new("#{data['error']['name']}: #{data['error']['message']}")
          e.set_backtrace([])
          e
        end
      end

      def pending_message
        STDERR.puts "pending_message not implemented" if Konacha.config.verbose
        nil
      end

      def described_class
        STDERR.puts "described_class not implemented" if Konacha.config.verbose
        nil
      end

      def pending
        data['status'] == "pending"
      end

      def description
        data['title']
      end

      def full_description
        data['fullTitle']
      end
    end
  end
end

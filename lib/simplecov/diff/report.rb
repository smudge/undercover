require 'multi_json'

module SimpleCov
  module Diff
    class Report
      def initialize(json:)
        self.raw = MultiJson.load(json).deep_symbolize_keys
      end

      def timestamp
        Time.at raw[:timestamp]
      end

      def files
        raw[:files].map { |data| File.new(data) }
      end

      def covered_percent
        metrics[:covered_percent]
      end

      def covered_strength
        metrics[:covered_strength]
      end

      def covered_lines
        metrics[:covered_lines]
      end

      def total_lines
        metrics[:total_lines]
      end

    private

      attr_accessor :raw

      def metrics
        raw[:metrics]
      end
    end
  end
end

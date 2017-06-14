require 'multi_json'
require 'active_support/core_ext/hash/keys'

module SimpleCov
  module Diff
    class Report
      def initialize(json:)
        self.raw = MultiJson.load(json).deep_symbolize_keys
      end

      def timestamp
        Time.at raw[:timestamp]
      end

    private

      attr_accessor :raw
    end
  end
end

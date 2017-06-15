module Undercover
  class File
    def initialize(raw_data)
      self.raw = raw_data.deep_symbolize_keys
    end

    def filename
      raw[:filename]
    end

    def covered_percent
      raw[:covered_percent]
    end

    def coverage
      @coverage ||= raw[:coverage].map { |i| i&.positive? }
    end

    def covered_strength
      raw[:covered_strength]
    end

    def covered_lines
      raw[:covered_lines]
    end

    def lines_of_code
      raw[:lines_of_code]
    end

  private

    attr_accessor :raw
  end
end

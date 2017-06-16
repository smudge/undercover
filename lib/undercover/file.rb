require 'pathname'

module Undercover
  class File
    def initialize(raw_data)
      self.raw = raw_data.deep_symbolize_keys
    end

    def filename
      @filename ||= relative_path.to_s
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

    def relative_path
      Pathname.new(raw[:filename]).relative_path_from(project_root)
    end

    def project_root
      # TODO: Solve this
      Pathname.new('/project/root')
    end

    attr_accessor :raw
  end
end

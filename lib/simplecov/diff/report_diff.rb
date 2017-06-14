module SimpleCov
  module Diff
    class ReportDiff
      def initialize(l_report, r_report)
        self.left = l_report
        self.right = r_report
      end

      def files
        files_by_filename.values
      end

    private

      def files_by_filename
        filenames.each_with_object({}) do |name, hsh|
          hsh[name] = FileDiff.new(left_files_by_filename[name]&.first,
                                   right_files_by_filename[name]&.first)
        end
      end

      def left_files_by_filename
        left.files.group_by(&:filename)
      end

      def right_files_by_filename
        right.files.group_by(&:filename)
      end

      def filenames
        left.files.map(&:filename) | right.files.map(&:filename)
      end

      attr_accessor :left, :right
    end
  end
end

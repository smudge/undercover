module Undercover
  class ReportDiff
    def initialize(l_report, r_report, renamed_files = {})
      self.left = l_report
      self.right = r_report
      self.renamed_files = renamed_files
    end

    def files
      files_by_filename.values
    end

    def changed_files
      files.select(&:changed?)
    end

  private

    attr_accessor :left, :right, :renamed_files

    def files_by_filename
      @files_by_filename ||= filenames.each_with_object({}) do |name, hsh|
        hsh[name] = FileDiff.new(left_files_by_filename[name]&.first,
                                 right_files_by_filename[name]&.first)
      end
    end

    def left_files_by_filename
      @left_files_by_filename ||= left.files.group_by { |file| renamed_files[file.filename] || file.filename }
    end

    def right_files_by_filename
      @right_files_by_filename ||= right.files.group_by(&:filename)
    end

    def filenames
      @filenames ||= left_files_by_filename.keys | right_files_by_filename.keys
    end
  end
end

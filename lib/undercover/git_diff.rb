require 'ostruct'

module Undercover
  class GitDiff
    attr_reader :files

    def initialize(string)
      self.files = parse_file_diffs(string)
    end

    def file_map
      @file_map ||= files.map { |f| [f.old_file, f.new_file] }.to_h
    end

  private

    attr_writer :files

    def parse_file_diffs(string) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity, Metrics/LineLength
      old_line = nil
      new_line = nil
      string.each_line.each_with_object([]) do |line, files|
        if line.start_with?('diff --git a/')
          old_file, new_file = line.split(' a/').last.split(' b/').map(&:strip)
          files << OpenStruct.new(old_file: old_file, new_file: new_file, chunks: [])
        elsif line.start_with?('@@')
          old_line, old_length, new_line, new_length = line.split(' ')[1..2].flat_map { |p| p.tr('-+', '').split(',').map(&:to_i) }
          files.last.chunks << OpenStruct.new(old_start: old_line, old_length: old_length, new_start: new_line, new_length: new_length, lines: []) # rubocop:disable Metrics/LineLength
        elsif line.start_with?(' ')
          old_line += 1 if files.last.chunks.last.lines.any?
          new_line += 1 if files.last.chunks.last.lines.any?
          files.last.chunks.last.lines << [old_line, new_line]
        elsif line.start_with?('+') && !line.start_with?('+++ ')
          new_line += 1 if files.last.chunks.last.lines.any?
          files.last.chunks.last.lines << [nil, new_line]
        elsif line.start_with?('-') && !line.start_with?('--- ')
          old_line += 1 if files.last.chunks.last.lines.any?
          files.last.chunks.last.lines << [old_line, nil]
        end
      end
    end
  end
end

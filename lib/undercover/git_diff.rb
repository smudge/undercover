module Undercover
  class GitDiff
    attr_reader :files

    def initialize(string)
      self.files = parse_file_diffs(string)
    end

  private

    attr_writer :files

    def parse_file_diffs(string) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity, Metrics/LineLength
      files = []
      current_file = nil
      current_chunk = nil
      old_line = nil
      new_line = nil
      string.each_line do |line|
        if line.start_with?('+++')
          current_file[:new_file] = line[4..-1]
        elsif line.start_with?('---')
          current_file[:chunks] << current_chunk if current_chunk
          files << current_file if current_file
          current_file = { old_file: line[4..-1], chunks: [] }
          current_chunk = nil
        elsif line.start_with?('@@')
          current_file[:chunks] << current_chunk if current_chunk
          old_line, old_length, new_line, new_length = line.split(' ')[1..2].flat_map { |p| p.tr('-+', '').split(',').map(&:to_i) }
          current_chunk = { old_start: old_line, old_length: old_length, new_start: new_line, new_length: new_length, lines: [] }
        elsif line.start_with?(' ')
          old_line += 1 if current_chunk[:lines].any?
          new_line += 1 if current_chunk[:lines].any?
          current_chunk[:lines] << [old_line, new_line]
        elsif line.start_with?('+')
          new_line += 1 if current_chunk[:lines].any?
          current_chunk[:lines] << [nil, new_line]
        elsif line.start_with?('-')
          old_line += 1 if current_chunk[:lines].any?
          current_chunk[:lines] << [old_line, nil]
        end
      end
      current_file[:chunks] << current_chunk if current_chunk
      files << current_file if current_file
      files
    end
  end
end

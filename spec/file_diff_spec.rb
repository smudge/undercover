require 'spec_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe SimpleCov::Diff::FileDiff do
  let(:left_file_data) do
    {
      'filename' => '/same/file/name.rb',
      'covered_percent' => 50.0,
      'coverage' => [nil, 1, 1, nil, nil, 1],
      'covered_strength' => 0.6,
      'covered_lines' => 3,
      'lines_of_code' => 6
    }
  end
  let(:right_file_data) do
    {
      'filename' => '/same/file/name.rb',
      'covered_percent' => 33.333333,
      'coverage' => [nil, 1, 0, nil, nil, 1],
      'covered_strength' => 0.4,
      'covered_lines' => 2,
      'lines_of_code' => 6
    }
  end
  let(:left_file) { SimpleCov::Diff::File.new(left_file_data) }
  let(:right_file) { SimpleCov::Diff::File.new(right_file_data) }

  subject { described_class.new(left_file, right_file) }

  describe '#filename' do
    it 'returns the correct file name' do
      expect(subject.filename).to eq '/same/file/name.rb'
    end
  end

  describe '#changed?' do
    it 'returns true if the coverage has changed' do
      expect(subject.changed?).to eq true
    end
  end
end

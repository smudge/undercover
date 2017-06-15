require 'spec_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe SimpleCov::Diff::File do
  let(:test_data) do
    {
      'filename' => '/home/user/rails/environment.rb',
      'covered_percent' => 50.0,
      'coverage' => [nil, 1, nil, nil, 1],
      'covered_strength' => 0.5,
      'covered_lines' => 2,
      'lines_of_code' => 4
    }
  end

  describe 'instance methods' do
    subject do
      described_class.new test_data
    end

    describe '#filename' do
      it 'returns the correct time' do
        expect(subject.filename).to eq '/home/user/rails/environment.rb'
      end
    end

    describe '#covered_percent' do
      it 'returns the correct time' do
        expect(subject.covered_percent).to eq 50.0
      end
    end

    describe '#coverage' do
      it 'returns the correct time' do
        expect(subject.coverage).to eq [nil, true, nil, nil, true]
      end
    end

    describe '#covered_strength' do
      it 'returns the correct time' do
        expect(subject.covered_strength).to eq 0.5
      end
    end

    describe '#covered_lines' do
      it 'returns the correct time' do
        expect(subject.covered_lines).to eq 2
      end
    end

    describe '#lines_of_code' do
      it 'returns the correct time' do
        expect(subject.lines_of_code).to eq 4
      end
    end
  end
end

require 'spec_helper'
require 'time'

# rubocop:disable Metrics/BlockLength
RSpec.describe Undercover::Report do
  let(:test_data) { MultiJson.load(test_json) }
  let(:test_json) do
    <<~JSON
      {
          "timestamp": 1348489587,
          "command_name": "RSpec",
          "files": [
              {
                  "filename": "/project/root/home/user/rails/environment.rb",
                  "covered_percent": 50.0,
                  "coverage": [
                      null,
                      1,
                      null,
                      null,
                      1
                  ],
                  "covered_strength": 0.50,
                  "covered_lines": 2,
                  "lines_of_code": 4
              }
          ],
          "metrics": {
                "covered_percent": 81.70731707317073,
                "covered_strength": 0.8170731707317073,
                "covered_lines": 67,
                "total_lines": 82
          }
      }
    JSON
  end

  describe '.load_file' do
    let(:tmp_file) do
      Tempfile.open(rand(36**25).to_s(36)) { |f| f.tap { |b| b.write(test_json) } }
    end

    it 'opens a file from a path, parses the contents, and passes the data into the initializer' do
      expect(described_class).to receive(:new).with(test_data)
      described_class.load_file(tmp_file.path)
    end
  end

  describe '.load' do
    it 'parses a string and passes the data to the inializer' do
      expect(described_class).to receive(:new).with(test_data)
      described_class.load(test_json)
    end
  end

  describe 'instance methods' do
    subject do
      described_class.new test_data
    end

    describe '#timestamp' do
      it 'returns the correct time' do
        expect(subject.timestamp).to eq Time.parse('Monday, 24-Sep-12 12:26:27 UTC')
      end
    end

    describe '#files' do
      it 'returns a list of objects' do
        expect(subject.files.length).to eq 1
        subject.files.first.tap do |file|
          expect(file.filename).to eq 'home/user/rails/environment.rb'
          expect(file.covered_percent).to eq 50.0
          expect(file.coverage).to eq [nil, true, nil, nil, true]
          expect(file.covered_strength).to eq 0.50
          expect(file.covered_lines).to eq 2
          expect(file.lines_of_code).to eq 4
        end
      end
    end

    describe '#covered_percent' do
      it 'returns the correct decimal value' do
        expect(subject.covered_percent).to eq 81.70731707317073
      end
    end

    describe '#covered_strength' do
      it 'returns the correct decimal value' do
        expect(subject.covered_strength).to eq 0.8170731707317073
      end
    end

    describe '#covered_lines' do
      it 'returns the correct integer value' do
        expect(subject.covered_lines).to eq 67
      end
    end

    describe '#total_lines' do
      it 'returns the correct integer value' do
        expect(subject.total_lines).to eq 82
      end
    end
  end
end

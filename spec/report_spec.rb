require 'spec_helper'
require 'time'

RSpec.describe SimpleCov::Diff::Report do # rubocop:disable Metrics/BlockLength
  subject do
    described_class.new json: <<~JSON
      {
          "timestamp": 1348489587,
          "command_name": "RSpec",
          "files": [
              {
                  "filename": "/home/user/rails/environment.rb",
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

  describe '#timestamp' do
    it 'returns the correct time' do
      expect(subject.timestamp).to eq Time.parse('Monday, 24-Sep-12 12:26:27 UTC')
    end
  end
end

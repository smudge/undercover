require 'spec_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe SimpleCov::Diff::ReportDiff do
  let(:left_report_data) do
    <<~JSON
      {
          "timestamp": 1348489587,
          "command_name": "RSpec",
          "files": [
              {
                  "filename": "/file/that/was/removed.rb",
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
              },
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

  let(:right_report_data) do
    <<~JSON
      {
          "timestamp": 1348489587,
          "command_name": "RSpec",
          "files": [
              {
                  "filename": "/file/that/was/added.rb",
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
              },
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
  let(:left_report) { SimpleCov::Diff::Report.load(left_report_data) }
  let(:right_report) { SimpleCov::Diff::Report.load(right_report_data) }

  subject { described_class.new(left_report, right_report) }

  describe '#files' do
    it 'outputs a unioned list of all files from both reports' do
      expect(subject.files.map(&:filename)).to match_array [
        '/file/that/was/removed.rb',
        '/home/user/rails/environment.rb',
        '/file/that/was/added.rb'
      ]
    end
  end
end

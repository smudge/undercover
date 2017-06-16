require 'spec_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe Undercover::ReportDiff do
  let(:left_report_data) do
    <<~JSON
      {
          "timestamp": 1348489587,
          "command_name": "RSpec",
          "files": [
              {
                  "filename": "/project/root/file/that/was/removed.rb",
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
                  "filename": "/project/root/file/that/did/not/change.rb",
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
                "filename": "/project/root/file/that/changed.rb",
                  "covered_percent": 50.0,
                  "coverage": [
                      null,
                      1,
                      1,
                      null,
                      null,
                      1
                  ],
                  "covered_strength": 0.50,
                  "covered_lines": 3,
                  "lines_of_code": 5
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
                  "filename": "/project/root/file/that/was/added.rb",
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
                "filename": "/project/root/file/that/changed.rb",
                  "covered_percent": 50.0,
                  "coverage": [
                      null,
                      1,
                      0,
                      null,
                      null,
                      1
                  ],
                  "covered_strength": 0.50,
                  "covered_lines": 2,
                  "lines_of_code": 5
              },
              {
                "filename": "/project/root/file/that/did/not/change.rb",
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
  let(:left_report) { Undercover::Report.load(left_report_data) }
  let(:right_report) { Undercover::Report.load(right_report_data) }

  subject { described_class.new(left_report, right_report) }

  describe '#files' do
    it 'outputs a unioned list of all files from both reports' do
      expect(subject.files.map(&:filename)).to match_array [
        'file/that/was/removed.rb',
        'file/that/changed.rb',
        'file/that/did/not/change.rb',
        'file/that/was/added.rb'
      ]
    end
  end

  describe '#changed_files' do
    it 'outputs a list of only the files with changed coverage' do
      expect(subject.changed_files.map(&:filename)).to match_array [
        'file/that/was/removed.rb',
        'file/that/was/added.rb',
        'file/that/changed.rb'
      ]
    end
  end

  context 'with renamed files' do
    let(:renamed_files) { { 'file/that/was/removed.rb' => 'file/that/was/added.rb' } }

    subject { described_class.new(left_report, right_report, renamed_files) }

    describe '#files' do
      it 'obeys renamed files' do
        expect(subject.files.map(&:filename)).to match_array [
          'file/that/changed.rb',
          'file/that/did/not/change.rb',
          'file/that/was/added.rb'
        ]
      end
    end

    describe '#changed_files' do
      it 'obeys renamed files' do
        expect(subject.changed_files.map(&:filename)).to match_array [
          'file/that/changed.rb'
        ]
      end
    end
  end
end

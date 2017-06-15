require 'spec_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe Undercover::GitDiff do
  let(:diff_string) do
    <<~EOF
      diff --git a/.rubocop.yml b/.rubocop.yml
      index 138364c..cfc4ff3 100644
      --- a/.rubocop.yml
      +++ b/.rubocop.yml
      @@ -1,5 +1,5 @@
       Metrics/LineLength:
      -  Max: 99
      +  Max: 140
       Style/AccessModifierIndentation:
         EnforcedStyle: outdent
       Style/Documentation:
      diff --git a/lib/undercover/report.rb b/lib/undercover/report.rb
      index f2a1f10..b15eac8 100644
      --- a/lib/undercover/report.rb
      +++ b/lib/undercover/report.rb
      @@ -6,10 +6,6 @@ module Undercover
           ::File.open(filename, 'r:bom|utf-8') { |str| load(str) }
         end

      -  def self.load(json)
      -    new MultiJson.load(json)
      -  end
      -
         def initialize(data)
           self.raw = data.deep_symbolize_keys
         end
      @@ -23,6 +19,7 @@ module Undercover
         end

         def covered_percent
      +    asdf
           metrics[:covered_percent]
         end
    EOF
  end

  subject { described_class.new(diff_string) }

  it 'returns the expected files and chunks' do
    expect(subject.files.length).to eq 2

    subject.files.first.tap do |file|
      expect(file.chunks.count).to eq 1
      file.chunks.first.tap do |chunk|
        expect(chunk.old_start).to eq 1
        expect(chunk.new_start).to eq 1
        expect(chunk.old_length).to eq 5
        expect(chunk.new_length).to eq 5
        expect(chunk.lines).to eq [[1, 1], [2, nil], [nil, 2], [3, 3], [4, 4], [5, 5]]
      end
    end

    subject.files.last.tap do |file|
      expect(file.chunks.count).to eq 2
      file.chunks.first.tap do |chunk|
        expect(chunk.old_start).to eq 6
        expect(chunk.new_start).to eq 6
        expect(chunk.old_length).to eq 10
        expect(chunk.new_length).to eq 6
        expect(chunk.lines).to eq [[6, 6], [7, 7], [8, nil], [9, nil], [10, nil], [11, nil], [12, 8], [13, 9], [14, 10]]
      end

      file.chunks.last.tap do |chunk|
        expect(chunk.old_start).to eq 23
        expect(chunk.new_start).to eq 19
        expect(chunk.old_length).to eq 6
        expect(chunk.new_length).to eq 7
        expect(chunk.lines).to eq [[23, 19], [24, 20], [nil, 21], [25, 22], [26, 23]]
      end
    end
  end
end

#!/usr/bin/env ruby

require 'fileutils'

(1..25).each do |i|
  2.times do |part|
    FileUtils.touch("inputs/day#{'%02d' % i}_part#{part+1}_example1")
    FileUtils.touch("inputs/day#{'%02d' % i}_part#{part+1}_expected1")
    FileUtils.touch("inputs/day#{'%02d' % i}_part#{part+1}_myinput")
    FileUtils.touch("inputs/day#{'%02d' % i}_part#{part+1}_myoutput")
  end
  ii = '%02d' % i

  File.write("days/#{ii}.rb", <<~CODE)
#!/usr/bin/env ruby

class Day#{ii}
  def initialize(input)
  end

  def run_part1
    raise NotImplementedError
  end

  def run_part2
    raise NotImplementedError
  end
end
  CODE

  File.write("spec/day#{ii}_spec.rb", <<~SPEC)
require_relative 'spec_helper'
require_relative '../days/#{ii}'
require 'date'

def custom_it(description, &block)
  day_threshold = $1.to_i if File.basename(__FILE__) =~ /day(.+)_spec.rb/
  if Date.today >= Date.new(2021, 12, day_threshold)
    it(description, &block)
  else
    pending(description, &block)
  end
end

describe 'day#{ii}' do
  dir = File.join(__dir__, '../inputs')

  describe 'part1' do
    describe 'official examples' do
      Dir.glob("\#{dir}/day#{ii}_part1_example*").each do |input_file|
        example_id = $1 if input_file =~ /example(.+)$/
        expected_output_file = "\#{dir}/day#{ii}_part1_expected\#{example_id}"

        expected_output = File.read(expected_output_file).to_i
        describe File.basename(input_file) do
          custom_it "solves example \#{example_id}" do
            solver = Day#{ii}.new(File.read(input_file))
            expect(solver.run_part1).to eq(expected_output)
          end
        end
      end
    end

    describe 'my input' do
      input_file = "\#{dir}/day#{ii}_part1_myinput"
      expected_output_file = "\#{dir}/day#{ii}_part1_myoutput"
      expected_output = File.read(expected_output_file).to_i

      custom_it "solves myinput" do
        solver = Day#{ii}.new(File.read(input_file))
        expect(solver.run_part1).to eq(expected_output)
      end
    end
  end

  describe 'part2' do
    describe 'official examples' do
      Dir.glob("\#{dir}/day#{ii}_part2_example*").each do |input_file|
        example_id = $1 if input_file =~ /example(.+)$/
        expected_output_file = "\#{dir}/day#{ii}_part2_expected\#{example_id}"

        expected_output = File.read(expected_output_file).to_i
        describe File.basename(input_file) do
          custom_it "solves example \#{example_id}" do
            solver = Day#{ii}.new(File.read(input_file))
            expect(solver.run_part2).to eq(expected_output)
          end
        end
      end
    end

    describe 'my input' do
      input_file = "\#{dir}/day#{ii}_part2_myinput"
      expected_output_file = "\#{dir}/day#{ii}_part2_myoutput"
      expected_output = File.read(expected_output_file).to_i

      custom_it "solves myinput" do
        solver = Day#{ii}.new(File.read(input_file))
        expect(solver.run_part2).to eq(expected_output)
      end
    end
  end
end
  SPEC
end

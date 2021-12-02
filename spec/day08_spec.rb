require_relative 'spec_helper'
require_relative '../days/08'
require 'date'

def custom_it(description, &block)
  day_threshold = $1.to_i if File.basename(__FILE__) =~ /day(.+)_spec.rb/
  if Date.today >= Date.new(2021, 12, day_threshold)
    it(description, &block)
  else
    pending(description, &block)
  end
end

describe 'day08' do
  dir = File.join(__dir__, '../inputs')

  describe 'part1' do
    describe 'official examples' do
      Dir.glob("#{dir}/day08_part1_example*").each do |input_file|
        example_id = $1 if input_file =~ /example(.+)$/
        expected_output_file = "#{dir}/day08_part1_expected#{example_id}"

        expected_output = File.read(expected_output_file).to_i
        describe File.basename(input_file) do
          custom_it "solves example #{example_id}" do
            solver = Day08.new(File.read(input_file))
            expect(solver.run_part1).to eq(expected_output)
          end
        end
      end
    end

    describe 'my input' do
      input_file = "#{dir}/day08_part1_myinput"
      expected_output_file = "#{dir}/day08_part1_myoutput"
      expected_output = File.read(expected_output_file).to_i

      custom_it "solves myinput" do
        solver = Day08.new(File.read(input_file))
        expect(solver.run_part1).to eq(expected_output)
      end
    end
  end

  describe 'part2' do
    describe 'official examples' do
      Dir.glob("#{dir}/day08_part2_example*").each do |input_file|
        example_id = $1 if input_file =~ /example(.+)$/
        expected_output_file = "#{dir}/day08_part2_expected#{example_id}"

        expected_output = File.read(expected_output_file).to_i
        describe File.basename(input_file) do
          custom_it "solves example #{example_id}" do
            solver = Day08.new(File.read(input_file))
            expect(solver.run_part2).to eq(expected_output)
          end
        end
      end
    end

    describe 'my input' do
      input_file = "#{dir}/day08_part2_myinput"
      expected_output_file = "#{dir}/day08_part2_myoutput"
      expected_output = File.read(expected_output_file).to_i

      custom_it "solves myinput" do
        solver = Day08.new(File.read(input_file))
        expect(solver.run_part2).to eq(expected_output)
      end
    end
  end
end

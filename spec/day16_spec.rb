require_relative 'spec_helper'
require_relative '../days/16'
require 'date'

def custom_it(description, &block)
  day_threshold = Regexp.last_match(1).to_i if File.basename(__FILE__) =~ /day(.+)_spec.rb/
  if Date.today >= Date.new(2021, 12, day_threshold)
    it(description, &block)
  else
    pending(description, &block)
  end
end

describe 'day16' do
  dir = File.join(__dir__, '../inputs')

  describe 'part1' do
    describe 'official examples' do
      part1 = Dir.glob("#{dir}/day16_example*")
      part1 -= Dir.glob("#{dir}/day16_example*_part2")
      part1.each do |input_file|
        example_id = Regexp.last_match(1) if input_file =~ /example(\d+)$/
        expected_output_file = "#{dir}/day16_expected#{example_id}_part1"

        expected_output = File.read(expected_output_file).to_i
        describe File.basename(input_file) do
          custom_it "solves example #{example_id}" do
            solver = Day16.new(File.read(input_file))
            expect(solver.run_part1).to eq(expected_output)
          end
        end
      end
    end

    describe 'my input' do
      input_file = "#{dir}/day16_myinput"
      expected_output_file = "#{dir}/day16_myoutput_part1"
      expected_output = File.read(expected_output_file).to_i

      custom_it 'solves myinput' do
        solver = Day16.new(File.read(input_file))
        expect(solver.run_part1).to eq(expected_output)
      end
    end
  end

  describe 'part2' do
    describe 'official examples' do
      part2_examples = Dir.glob("#{dir}/day16_example*_part2")
      part2_examples += Dir.glob("#{dir}/day16_example*") if part2_examples.empty?

      part2_examples.each do |input_file|
        example_id = Regexp.last_match(1) if input_file =~ /example(\d+)(_part2)?$/
        expected_output_file = "#{dir}/day16_expected#{example_id}_part2"

        expected_output = File.read(expected_output_file).to_i
        describe File.basename(input_file) do
          custom_it "solves example #{example_id}" do
            solver = Day16.new(File.read(input_file))
            expect(solver.run_part2).to eq(expected_output)
          end
        end
      end
    end

    describe 'my input' do
      input_file = "#{dir}/day16_myinput"
      expected_output_file = "#{dir}/day16_myoutput_part2"
      expected_output = File.read(expected_output_file).to_i

      custom_it 'solves myinput' do
        solver = Day16.new(File.read(input_file))
        expect(solver.run_part2).to eq(expected_output)
      end
    end
  end
end

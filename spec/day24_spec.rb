require_relative 'spec_helper'
require_relative '../days/24'

describe 'day24' do
  dir = File.join(__dir__, '../inputs')

  describe 'part1' do
    describe 'official examples' do
      Dir.glob("#{dir}/day24_part1_example*").each do |input_file|
        example_id = $1 if input_file =~ /example(.+)$/
        expected_output_file = "#{dir}/day24_part1_expected#{example_id}"

        expected_output = File.read(expected_output_file).to_i
        describe File.basename(input_file) do
          pending "solves example #{example_id}" do
            solver = Day24.new(File.read(input_file))
            expect(solver.run_part1).to eq(expected_output)
          end
        end
      end
    end

    describe 'my input' do
      input_file = "#{dir}/day24_part1_myinput"
      expected_output_file = "#{dir}/day24_part1_myoutput"
      expected_output = File.read(expected_output_file).to_i

      pending "solves myinput" do
        solver = Day24.new(File.read(input_file))
        expect(solver.run_part1).to eq(expected_output)
      end
    end
  end

  describe 'part2' do
    describe 'official examples' do
      Dir.glob("#{dir}/day24_part2_example*").each do |input_file|
        example_id = $1 if input_file =~ /example(.+)$/
        expected_output_file = "#{dir}/day24_part2_expected#{example_id}"

        expected_output = File.read(expected_output_file).to_i
        describe File.basename(input_file) do
          pending "solves example #{example_id}" do
            solver = Day24.new(File.read(input_file))
            expect(solver.run_part2).to eq(expected_output)
          end
        end
      end
    end

    describe 'my input' do
      input_file = "#{dir}/day24_part2_myinput"
      expected_output_file = "#{dir}/day24_part2_myoutput"
      expected_output = File.read(expected_output_file).to_i

      pending "solves myinput" do
        solver = Day24.new(File.read(input_file))
        expect(solver.run_part2).to eq(expected_output)
      end
    end
  end
end

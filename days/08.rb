#!/usr/bin/env ruby

class Day08
  def initialize(input)
    @lines = input.split("\n").map { |line| Line.parse(line) }
  end

  def run_part1
    @lines.map do |line|
      line.output_digits.count do |digit|
        [2, 3, 4, 7].include?(digit.size)
      end
    end.sum
  end

  def run_part2
    @lines.map do |line|
      association = {}
      # segment f is used in all numbers except "2"
      frequencies = line.patterns.flatten.group_by(&:itself).transform_values(&:size)
      f_code = frequencies.find { |w, count| count == 9 }.first
      raise "Unable to find what corresponds to segment f" unless f_code

      # puts "When #{f_code} is light up, we are trying to light up f"
      code_for_2 = line.patterns.find { |pattern| !pattern.include?(f_code)}
      association[code_for_2] = 2
      # puts "#{code_for_2.join} means we aimed to display 2"

      # now we detect the wires corresponding to "1" and wire for "c"
      code_for_1 = line.patterns.select { |p| p.size == 2 }.first
      c_code = (code_for_1 - [f_code]).first
      # puts "When #{c_code} is light up, we are trying to light up c"
      association[code_for_1] = 1
      # puts "#{code_for_1.join} means we aimed to display 1"

      # now we detect the wires usde for "7" and the wire for "a"
      code_for_7 = line.patterns.select { |p| p.size == 3 }.first
      a_code = (code_for_7 - [f_code, c_code]).first
      # puts "When #{a_code} is light up, we are trying to light up a"
      association[code_for_7] = 7
      # puts "#{code_for_7.join} means we aimed to display 7"

      # now we detect wires used for e
      e_code = frequencies.find { |w, count| count == 4 }.first
      raise "Unable to find what corresponds to segment e" unless e_code

      # puts "When #{e_code} is light up, we are trying to light up e"

      # now we detect wires used for b
      b_code = frequencies.find { |w, count| count == 6 }.first
      raise "Unable to find what corresponds to segment b" unless b_code

      # puts "When #{b_code} is light up, we are trying to light up b"

      # now we detect the wires usde for "4" and the wire for "d"
      code_for_4 = line.patterns.select { |p| p.size == 4 }.first
      d_code = (code_for_4 - [f_code, c_code, b_code]).first
      # puts "When #{d_code} is light up, we are trying to light up d"
      association[code_for_4] = 4
      # puts "#{code_for_4.join} means we aimed to display 4"

      # last unknown wire is g
      g_code = (('a'..'g').to_a - [a_code, b_code, c_code, d_code, e_code, f_code]).first
      # puts "When #{g_code} is light up, we are trying to light up g"

      # missing numbers can now be deduced easily
      association[[a_code, c_code, d_code, f_code, g_code]] = 3
      association[[a_code, b_code, d_code, f_code, g_code]] = 5
      association[[a_code, b_code, d_code, e_code, f_code, g_code]] = 6
      association[[a_code, b_code, c_code, d_code, e_code, f_code, g_code]] = 8
      association[[a_code, b_code, c_code, d_code, f_code, g_code]] = 9
      association[[a_code, b_code, c_code, e_code, f_code, g_code]] = 0

      association = association.map { |k,v| [k.sort, v]}.to_h

      intended_output = line.output_digits.map do |digit_codes|
        if !association.key?(digit_codes)
          puts "#{digit_code} not found in association table"
          require 'pry'
          binding.pry
        end
        association[digit_codes].to_s
      end.join
      intended_output.to_i
    end.sum
  end

  class Line
    def self.parse(line)
      patterns, output = line.split("|").map(&:strip).map { |el| el.split(' ').map {|code| code.chars.sort } }
      Line.new(patterns, output)
    end
    def initialize(patterns, output_digits)
      @patterns = patterns
      @output_digits = output_digits
    end
    attr_reader :patterns, :output_digits



  end
end

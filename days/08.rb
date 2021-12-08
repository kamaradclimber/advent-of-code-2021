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
    raise NotImplementedError
  end

  class Line
    def self.parse(line)
      patterns, output = line.split("|").map(&:strip).map { |el| el.split(' ').map {|code| code.chars } }
      Line.new(patterns, output)
    end
    def initialize(patterns, output_digits)
      @patterns = patterns
      @output_digits = output_digits
    end
    attr_reader :patterns, :output_digits



  end
end

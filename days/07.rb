#!/usr/bin/env ruby

class Day07
  def initialize(input)
    @positions = input.split(',').map(&:to_i)
  end

  def run_part1
    (@positions.min..@positions.max).map do |pos|
      @positions.map { |p| (pos - p).abs }.sum
    end.min
  end

  def run_part2
    (@positions.min..@positions.max).map do |pos|
      @positions.map { |p| n = (pos - p).abs; n * (n+1)/2 }.sum
    end.min
  end
end

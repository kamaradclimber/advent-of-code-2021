#!/usr/bin/env ruby

class Day01
  def initialize(input)
    @depth = input.split("\n").map(&:to_i)
  end

  def run_part1
    @depth.each_cons(2).count do |a, b|
      b > a
    end
  end

  def run_part2
    raise NotImplementedError
  end
end

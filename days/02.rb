#!/usr/bin/env ruby

class Day02
  def initialize(input)
    @depth = 0
    @horizontal = 0
    @aim = 0
    @input = input
  end

  def run_part1
    @input.split("\n").each do |line|
      case line
      when /forward (\d+)/
        @horizontal += $1.to_i
      when /down (\d+)/
        @depth += $1.to_i
      when /up (\d+)/
        @depth -= $1.to_i
      end
    end
    @depth * @horizontal
  end

  def run_part2
    @input.split("\n").each do |line|
      case line
      when /forward (\d+)/
        @horizontal += $1.to_i
        @depth += @aim * $1.to_i
      when /down (\d+)/
        @aim += $1.to_i
      when /up (\d+)/
        @aim -= $1.to_i
      end
    end
    @depth * @horizontal
  end
end

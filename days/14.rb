#!/usr/bin/env ruby

class Day14
  def initialize(input)
    polymer, rules = input.split("\n\n")
    @polymer = polymer.chars
    @rules = rules.split("\n").map do |line|
      [Regexp.last_match(1).chars, Regexp.last_match(2)] if line =~ /(.+) -> (.+)/
    end.to_h
  end

  def run_part1
    10.times do
      puts "Polymer: #{@polymer.take(10).join('')}, size #{@polymer.size}"
      @polymer = @polymer.each_cons(2).map do |pair|
        a, b = pair
        [a, @rules[pair]].compact
      end.flatten + [@polymer.last]
    end
    frequencies = @polymer.group_by(&:itself).transform_values(&:size)
    top = frequencies.max_by { |_, count| count }
    low = frequencies.min_by { |_, count| count }
    puts "most frequent #{top[0]} with #{top[1]} elements"
    puts "least frequent #{low[0]} with #{low[1]} elements"
    top[1] - low[1]
  end

  def run_part2
    raise NotImplementedError
  end
end

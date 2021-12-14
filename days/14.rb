#!/usr/bin/env ruby

class Day14
  def initialize(input)
    polymer, rules = input.split("\n\n")
    @polymer = polymer.chars
    @rules = rules.split("\n").map do |line|
      [$1.chars, $2] if line =~ /(.+) -> (.+)/
    end.to_h
  end

  def run_part1
    run(10)
  end

  def run_part2
    run(40)
  end

  def run(iterations)
    pair_count = Hash.new(0)
    @polymer.each_cons(2) do |pair|
      pair_count[pair] += 1
    end
    iterations.times do
      new_pairs = Hash.new(0)
      pair_count.each do |pair, count|
        a, b = pair
        c = @rules[pair]
        new_pairs[[a,c]] += count
        new_pairs[[c,b]] += count
      end
      pair_count = new_pairs
    end

    frequencies = Hash.new(0)
    pair_count.each do |pair, count|
      a, b = pair
      frequencies[a] += count
      frequencies[b] += count
    end
    frequencies = frequencies.map do |letter, count|
      c = count / 2
      c += 1 if letter == @polymer.first || letter == @polymer.last
      [letter, c]
    end.to_h
    top = frequencies.max_by { |_, count| count }
    low = frequencies.min_by { |_, count| count }
    top[1] - low[1]
  end
end

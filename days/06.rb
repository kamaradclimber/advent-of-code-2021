#!/usr/bin/env ruby

class Day06
  def initialize(input)
    @population = [0] * 9
    input.split(',').map(&:to_i).each do |lanternfish|
      @population[lanternfish] += 1
    end
  end

  def run_part1
    80.times do |day|
      tick
    end
    @population.sum
  end

  def run_part2
    256.times do |day|
      tick
    end
    @population.sum
  end

  def tick
    new_population = [0] * 9
    @population.each_with_index do |count, timer|
      if timer == 0
        new_population[6] += count
        new_population[8] += count # new lanternfish
      else
        new_population[timer-1] += count
      end
    end
    @population = new_population
  end
end

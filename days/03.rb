#!/usr/bin/env ruby

class Day03
  def initialize(input)
    @input = input.split("\n").map(&:chars)
  end

  def run_part1
    gamma = @input.transpose.map do |column|
      frequencies = column.group_by(&:itself).transform_values(&:size)
      epsilon_bit = frequencies.min_by { |_, count| count }.first
      gamma_bit = frequencies.max_by { |_, count| count }.first
      # epsilon bit is the opposite of gamma_bit
      gamma_bit
    end.join.to_i(2)
    epsilon = (2 ** @input.first.size - 1) ^ gamma
    epsilon * gamma
  end

  def run_part2
    oxygen_rating = rating(@input, 0) do |frequencies|
      zeros = frequencies["0"]&.size || 0
      ones = frequencies["1"]&.size || 0
      ones >= zeros ? "1" : "0"
    end.join.to_i(2)
    co2_rating = rating(@input, 0) do |frequencies|
      zeros = frequencies["0"]&.size || 0
      ones = frequencies["1"]&.size || 0
      ones >= zeros ? "0" : "1"
    end.join.to_i(2)
    oxygen_rating * co2_rating
  end

  # recursively select numbers until only one remains
  # @param numbers [Array<Array<String>>]
  def rating(numbers, index, &block)
    return numbers.first if numbers.one?

    frequencies = numbers.group_by do |number|
      number[index]
    end

    bit_criteria = block.call(frequencies)
    rating(frequencies[bit_criteria], index + 1, &block)
  end
end

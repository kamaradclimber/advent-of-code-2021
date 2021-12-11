#!/usr/bin/env ruby
# frozen_string_literal: true

class Day11
  def initialize(input)
    @octopuses = input.split("\n").map do |line|
      line.chars.map do |c|
        Octopus.new(c.to_i)
      end
    end
  end

  def run_part1
    100.times.map { tick }
    @octopuses.flatten.map(&:flashes).sum
  end

  class Octopus
    def initialize(energy_level)
      @energy_level = energy_level
      @already_flashed = false
      @flashes = 0
    end

    # @return [Integer] number of time this octopus flashed
    attr_reader :flashes

    attr_reader :energy_level

    def charge
      @energy_level += 1
    end

    def already_flashed?
      @already_flashed
    end

    def should_flash?
      @energy_level > 9 && !@already_flashed
    end

    def flash!
      @already_flashed = true
      @flashes += 1
    end

    def next_turn
      @already_flashed = false
      @energy_level = 0 if @energy_level > 9
    end
  end

  # return [Array<Array<(Integer,Integer)>>] list of coordinates of octopuses neighboring
  def neighbors(x, y)
    [
      [x - 1, y - 1], [x, y - 1], [x + 1, y - 1],
      [x - 1, y],             [x + 1, y],
      [x - 1, y + 1], [x, y + 1], [x + 1, y + 1]
    ].select do |xx, yy|
      xx >= 0 && xx < 10 && yy >= 0 && yy < 10
    end
  end

  # @return [Integer] number of flashes during this step
  def tick
    @octopuses.map do |line|
      line.map(&:charge)
    end
    check_charge = true
    while check_charge
      check_charge = false
      to_charge = []

      @octopuses.each_with_index do |line, y|
        line.each_with_index do |octo, x|
          next unless octo.should_flash?

          octo.flash!
          to_charge += neighbors(x, y)
          check_charge = true
        end
      end
      to_charge.each do |x, y|
        @octopuses[y][x].charge
      end
    end
    @octopuses.map do |line|
      line.map(&:next_turn)
    end
  end

  def run_part2
    (1..).each do |i|
      tick
      return i if @octopuses.flatten.all? { |octo| octo.energy_level.zero? }
    end
  end
end

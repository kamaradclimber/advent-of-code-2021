#!/usr/bin/env ruby

require 'set'

class Day15
  def initialize(input)
    @input = input.split("\n").map { |line| line.chars.map(&:to_i) }
  end

  INF = 2**32

  def run_part1
    visited = Set.new
    to_explore = []
    distances = {}
    to_explore << [0, 0]
    distances[[0, 0]] = 0
    while to_explore.any?
      position = to_explore.min_by { |x, y| distances[[x, y]] }
      to_explore.delete(position)
      visited << position
      neighbors_coords(*position).each do |xx, yy|
        new_cost = distances[position] + @input[yy][xx]
        if distances[[xx, yy]].nil? || new_cost < distances[[xx, yy]]
          distances[[xx, yy]] = new_cost
          to_explore << [xx, yy]
        end
      end
    end
    distances[[@input.first.size - 1, @input.size - 1]]
  end

  def run_part2
    raise NotImplementedError
  end

  def neighbors_coords(x, y)
    coords = [[x - 1, y], [x + 1, y], [x, y - 1], [x, y + 1]]
    coords.select do |xx, yy|
      xx >= 0 && xx < @input.first.size && yy >= 0 && yy < @input.size
    end
  end
end

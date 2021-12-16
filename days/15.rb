#!/usr/bin/env ruby

require 'set'

class Day15
  def initialize(input)
    @input = input.split("\n").map { |line| line.chars.map(&:to_i) }
  end

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

  class Node
    # the object needs to be immutable to be used in sorted set
    def initialize(x,y, current_cost)
      @x = x
      @y = y
      @current_cost = current_cost
    end

    include Comparable
    attr_reader :x,:y,:current_cost

    def <=>(other)
      @current_cost <=> other.current_cost
    end
  end

  def run_part2
    visited = Set.new
    to_explore = SortedSet.new
    distances = {}
    to_explore << Node.new(0, 0, 0)
    distances[[0, 0]] = 0

    steps = 0
    start = Time.now

    while to_explore.any?
      steps += 1
      # puts "#{to_explore.size} remaining to explore. #{steps / (Time.now - start).to_f} step/ms" if steps % 100 == 0
      node = to_explore.first
      to_explore.delete(node)
      visited << [node.x, node.y]
      neighbors_coords_part2(node.x,node.y).each do |xx, yy|
        new_cost = distances[[node.x,node.y]] + entry_cost_part2(xx, yy)
        if distances[[xx, yy]].nil? || new_cost < distances[[xx, yy]]
          distances[[xx, yy]] = new_cost
          to_explore << Node.new(xx, yy, new_cost)
        end
      end
    end

    distances[[@input.first.size * 5 - 1, @input.size * 5 - 1]]
  end

  def entry_cost_part2(x, y)
    qx, rx = x.divmod(@input.first.size)
    qy, ry = y.divmod(@input.size)
    delta = qx + qy

    full = (@input[ry][rx] + delta)
    _q, r = full.divmod(9)
    r.zero? ? 9 : r
  end

  def neighbors_coords_part2(x, y)
    coords = [[x - 1, y], [x + 1, y], [x, y - 1], [x, y + 1]]
    coords.select do |xx, yy|
      xx >= 0 && xx < @input.first.size * 5 && yy >= 0 && yy < @input.size * 5
    end
  end

  def neighbors_coords(x, y)
    coords = [[x - 1, y], [x + 1, y], [x, y - 1], [x, y + 1]]
    coords.select do |xx, yy|
      xx >= 0 && xx < @input.first.size && yy >= 0 && yy < @input.size
    end
  end
end

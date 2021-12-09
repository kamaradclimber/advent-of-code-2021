#!/usr/bin/env ruby

class Day09
  def initialize(input)
    @input = input.split("\n").map(&:chars).map { |line| line.map(&:to_i) }
  end

  def run_part1
    risk_level = 0
    @input.each_with_index do |line, y|
      line.each_with_index do |heigh, x|
        low_point = neighbors_coords(x, y).all? do |xx, yy|
          heigh < @input[yy][xx]
        end
        if low_point
          risk_level += 1 + heigh
        end
      end
    end
    risk_level
  end

  def run_part2
    basins = {} # for each (x,y) coords, associate the coords of the basin low-point

    @input.each_with_index do |line, y|
      line.each_with_index do |heigh, x|
        low_point = neighbors_coords(x, y).all? do |xx, yy|
          heigh < @input[yy][xx]
        end
        basins[[x, y]] = [x, y] if low_point
      end
    end

    to_explore = Queue.new
    (0...@input.size).each do |y|
      (0...@input.first.size).each do |x|
        to_explore << [x, y]
      end
    end

    until to_explore.empty?
      x, y = to_explore.pop
      next if @input[y][x] == 9 # full wall in the cave

      known_basin = neighbors_coords(x, y).map do |xx, yy|
        basins[[xx, yy]]
      end.compact.first
      if known_basin
        basins[[x, y]] = known_basin
      else
        to_explore << [x, y] # we'll deal with it in a later run
      end
    end

    basins
      .group_by { |_coords, low_point_coords| low_point_coords }.transform_values(&:size)
      .sort_by { |_low_point, basin_size| basin_size }.last(3)
      .map { |_low_point, basin_size| basin_size }.reduce(&:*)
  end

  def neighbors_coords(x, y)
    coords = [[x - 1, y], [x + 1, y], [x, y - 1], [x, y + 1]]
    coords.select do |xx, yy|
      xx >= 0 && xx < @input.first.size && yy >= 0 && yy < @input.size
    end
  end
end

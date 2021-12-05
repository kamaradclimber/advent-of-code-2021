#!/usr/bin/env ruby

class Day05
  def initialize(input)
    @lines = input.split("\n").map do |line|
      Line.parse(line)
    end
  end

  def run_part1
    points = Hash.new(0)
    @lines.reject(&:diagonal?).each do |line|
      line.points.each do |point|
        points[point] += 1
      end
    end
    points.count { |_point, count| count >= 2 }
  end

  def run_part2
    points = Hash.new(0)
    @lines.each do |line|
      line.points.each do |point|
        points[point] += 1
      end
    end
    points.count { |_point, count| count >= 2 }
  end

  def myprint(points)
    minx = points.map { |p, _| p[0] }.min
    maxx = points.map { |p, _| p[0] }.max
    miny = points.map { |p, _| p[1] }.min
    maxy = points.map { |p, _| p[1] }.max

    (miny..maxy).each do |y|
      (minx..maxx).each do |x|
        print (points[[x,y]] || '.')
      end
      puts ''
    end
  end

  class Line
    def initialize(x1, y1, x2, y2)
      @x1 = x1
      @x2 = x2
      @y1 = y1
      @y2 = y2
    end

    def self.parse(line)
      Line.new($1.to_i, $2.to_i, $3.to_i, $4.to_i) if line =~ /(\d+),(\d+) -> (\d+),(\d+)/
    end

    def diagonal?
      @x1 != @x2 && @y1 != @y2
    end

    # @return [Array<Array>]
    def points
      if @x1 == @x2
        ([@y1, @y2].min..[@y1,@y2].max).map do |y|
          [@x1, y]
        end
      elsif @y1 == @y2
        ([@x1, @x2].min..[@x1,@x2].max).map do |x|
          [x, @y1]
        end
      else # we now x1 != x2 so we can derive
        xa, ya, xb, yb = if @x1 < @x2
                           [@x1, @y1, @x2, @y2]
                         else
                           [@x2, @y2, @x1, @y1]
                         end

        slope = (yb - ya) / (xb - xa)
        raise "Lines is not 45deg: #{self} (slope is #{slope})" unless slope.abs == 1 || slope == 0

        (xa..xb).map do |x|
          [x, ya + slope * (x-xa)]
        end
      end
    end

    def to_s
      "(#{@x1},#{@y1}) -> (#{@x2},#{@y2})"
    end

  end
end

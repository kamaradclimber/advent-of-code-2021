#!/usr/bin/env ruby

require 'pry'

class Day17
  def initialize(input)
    # target area: x=244..303, y=-91..-54
    input =~ /target area: x=(.+)\.\.(.+), y=(.+)\.\.(.+)/
  @xm = $1.to_i
  @xM = $2.to_i
  @ym = $3.to_i
  @yM = $4.to_i
  end

  def run_part1
    possible_velocities = []
    (-10..100).each do |vx0|
      (-100..100).each do |vy0|
        possible_velocities << [vx0,vy0]
      end
    end
    possible_velocities.map { |vx0,vy0| enter_zone?(vx0,vy0) }.compact.max
  end

  def run_part2
    possible_velocities = []
    (0..@xM).each do |vx0|
      (-100..100).each do |vy0|
        possible_velocities << [vx0,vy0]
      end
    end
    possible_velocities.map { |vx0,vy0| enter_zone?(vx0,vy0) }.compact.size
  end

  # @return [Integer, nil] the maxy if entering the zone or nil if we never enter
  def enter_zone?(vx0,vy0)
    t = 0
    ax = -1
    ay = -1
    vx = vx0
    vy = vy0
    x = 0
    y = 0
    maxy = 0
    loop do
      x += vx
      y += vy
      maxy = [maxy,y].max
      # puts "(#{x},#{y}), speed vector (#{vx},#{vy})"
      return if x > @xM
      return if y < @ym && vy < 0 # at this point vx is negative, we assume we wont find a solution

      return maxy if x >= @xm && x <= @xM && y >= @ym && y <= @yM

      t += 1
      ax = 0 if vx == 0
      vx += ax
      vy += ay
    end
  end
end

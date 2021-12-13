#!/usr/bin/env ruby

class Day13
  def initialize(input)
    dots_string, folds_string = input.split("\n\n")
    @dots = dots_string.split("\n").map do |line|
      line.split(',').map(&:to_i)
    end
    @folds = folds_string.split("\n")
  end

  def run_part1
    if @folds.first =~ /fold along (.)=(\d+)/
      axis = Regexp.last_match(1)
      coord = Regexp.last_match(2)
    end
    fold_once(@dots, axis, coord.to_i).size
  end

  # @return [Array<Array<(Integer,Integer)>>]
  def fold_once(dots, axis, coord)
    case axis
    when 'y'
      dots.map do |x, y|
        case y
        when (0...coord)
          [x, y]
        when coord # ignoring
          # raise "Dots on line?"
        else
          [x, coord - (y - coord)]
        end
      end.compact.uniq
    else
      # there is probably a smart way to avoid rewriting this code
      dots.map do |x, y|
        case x
        when (0...coord)
          [x, y]
        when coord # ignoring
          # raise "Dots on line?"
        else
          [coord - (x - coord), y]
        end
      end.compact.uniq
    end
  end

  def dot_print
    max_x = @dots.map { |x, _| x }.max
    max_y = @dots.map { |_, y| y }.max
    my_dots = @dots.map { |p| [p, '#'] }.to_h
    my_dots.default = '.'
    (0..max_y).each do |y|
      (0..max_x).each do |x|
        print my_dots[[x, y]]
      end
      puts ''
    end
  end

  def run_part2
    @folds.each_with_index do |fold, _i|
      if fold =~ /fold along (.)=(\d+)/
        axis = Regexp.last_match(1)
        coord = Regexp.last_match(2)
      end
      @dots = fold_once(@dots, axis, coord.to_i)
    end
    #    puts "Result:"
    #    dot_print
    # FIXME: we should find a way to recognize letters automatically
    0
  end
end

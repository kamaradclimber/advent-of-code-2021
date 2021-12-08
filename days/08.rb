#!/usr/bin/env ruby

class Day08
  def initialize(input)
    @lines = input.split("\n").map { |line| Line.parse(line) }
  end

  def run_part1
    @lines.map do |line|
      line.output_digits.count do |digit|
        [2, 3, 4, 7].include?(digit.size)
      end
    end.sum
  end

  def run_part2
    @lines = "acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf".split("\n").map { |line| Line.parse(line) }
    @lines.each_with_index.map do |line, index|
      puts "Solving line #{index}"
      wires = ('a'..'g').map { |input_segment| [input_segment, Wire.new(input_segment)] }.to_h
      line.patterns.each do |digit|
        case digit.size
        when 2
          digit.each { |input_segment| wires[input_segment].restrict('cf'.chars) }
        when 3
          digit.each { |input_segment| wires[input_segment].restrict('acf'.chars) }
        when 4
          digit.each { |input_segment| wires[input_segment].restrict('bcdf'.chars) }
        when 7
          digit.each { |input_segment| wires[input_segment].restrict('abcdefg'.chars) }
        end
      end

      unknown = wires.size
      loop do
        # solve manually the case of number 1
        # wires.values.each do |wire|
        #   next if wire.possible_output_segments == 'cf'.chars
        #   wire.reject('cf'.chars)
        # end
        wires.values.each do |wire|
          puts wire
        end
        wires.values.select(&:known?).each do |known_wire|
          puts "We know the value of #{known_wire}"
          wires.values.each do |wire|
            next if wire.known?

            wire.reject(known_wire.possible_output_segments)
          end
        end
        grouped_wires = wires.values.reject(&:known?).group_by(&:possible_output_segments)
        self_sufficient_groups = grouped_wires.select { |possibles, g_wires| possibles.size == g_wires.size }
        self_sufficient_groups.each do |possibles, g_wires|
          puts "#{g_wires.map(&:input_segment).join(', ')} have the same possibilities (#{possibles.join(',')})"
          wires.values.each do |wire|
            next if g_wires.include?(wire)
            puts "#{wire.input_segment} cannot be correspond to #{possibles.join(', ')}"
            wire.reject(possibles)
          end
          # TODO: exclude this possibilities from other segments
        end

        break if wires.values.all?(&:known?)
        new_unknown = wires.size - wires.values.count(&:known?)
        puts "Before this iteration #{unknown} unknowns, now #{new_unknown}"
        if unknown == new_unknown
          require 'pry'
          binding.pry
        end
        unknown = new_unknown
      end



    end
  end

  class Wire
    attr_reader :possible_output_segments, :input_segment

    def initialize(input_segment)
      @input_segment = input_segment
      @possible_output_segments = 'abcdefg'.chars
    end

    def restrict(possible)
      @possible_output_segments &= possible
      return @possible_output_segments.first if @possible_output_segments.one?
      raise "Impossible!" if @possible_output_segments.empty?
      nil
    end

    def reject(impossible)
      @possible_output_segments -= Array(impossible)
    end

    def known?
      @possible_output_segments.one?
    end

    def to_s
      "#{@input_segment} -> #{@possible_output_segments.join(', ')}"
    end
  end

  class Line
    def self.parse(line)
      patterns, output = line.split("|").map(&:strip).map { |el| el.split(' ').map {|code| code.chars } }
      Line.new(patterns, output)
    end
    def initialize(patterns, output_digits)
      @patterns = patterns
      @output_digits = output_digits
    end
    attr_reader :patterns, :output_digits



  end
end

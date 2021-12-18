#!/usr/bin/env ruby

require 'json'

class Day18
  def initialize(input)
    @numbers = input.split("\n").map { |line| parse_tree(JSON.parse(line)) }
  end

  def parse_tree(array)
    case array
    when Integer
      Leaf.new(array)
    when Array
      Tree.new(array.map { |el| parse_tree(el) })
    else
      raise "Unparsable #{array}"
    end
  end

  def run_part1
    result = @numbers.inject(&:+)
    result.magnitude
  end

  def run_part2
    i = 0
    @numbers.combination(2).flat_map do |n1,n2|
      i+=1
      puts "Solving #{i}th combination out of #{@numbers.size * (@numbers.size-1) / 2}"
      [n1.dup + n2.dup, n2.dup+n1.dup]
    end.map(&:magnitude).max
  end

  class Tree
    def initialize(subtrees)
      @subtrees = subtrees
      @subtrees.each do |t|
        t.ancestor = self
      end
      @height = @subtrees.map(&:height).max + 1
    end

    def update_height!
      @height = @subtrees.map(&:update_height!).max + 1
    end

    def dup
      Tree.new(@subtrees.map(&:dup))
    end

    attr_accessor :ancestor

    attr_reader :subtrees

    attr_accessor :height

    def magnitude
      raise "Tree has more than 2 subtrees" if @subtrees.size != 2

      left,right = @subtrees

      3 * left.magnitude + 2 * right.magnitude
    end

    def add_and_reduce(other)
      sum = add(other)
      loop do
        break unless sum.reduce
      end
      sum
    end

    alias_method :+, :add_and_reduce

    def add(other)
      Tree.new([self,other])
    end

    def reduce
      # puts "Will try to reduce: #{self}"
      if explode?
        explode!
        true
      elsif split?
        split!
        true
      else
        false
      end
    end

    def to_a
      @subtrees.map(&:to_a)
    end

    def to_s
      to_a.to_json
    end

    def explode?
      height >= 5
    end

    def explode!
      tree = self
      until tree.height == 1
        left, right = tree.subtrees
        if left.height >= right.height
          tree = left
        else
          tree = right
        end
      end
      # puts "Pair to explode in #{self} is #{tree}, parent is #{tree.ancestor}"
      left_number = tree.subtrees.first.element
      right_number = tree.subtrees.last.element
      tree.add_left(left_number)
      tree.add_right(right_number)
      tree.replace!(Leaf.new(0))
      self
    end

    # replace the tree by a new one in its ancestor
    def replace!(new_self)
      i = self.ancestor.subtrees.find_index(self)
      self.ancestor.subtrees[i] = new_self
      new_self.ancestor = self.ancestor
      top_level_ancestor.update_height!
      new_self
    end

    def add_right(number)
      leaves = top_level_ancestor.all_leaves
      my_index = leaves.find_index(self.subtrees.last)
      raise "I could not find myself in the list of mini trees" unless my_index
      return if my_index == leaves.size - 1
      # puts "Adding #{number} to #{leaves[my_index+1]}"
      leaves[my_index+1].element += number
    end

    def add_left(number)
      leaves = top_level_ancestor.all_leaves
      my_index = leaves.find_index(self.subtrees.first)
      raise "I could not find myself in the list of mini trees" unless my_index
      return unless my_index > 0
      # puts "Adding #{number} to #{leaves[my_index-1]}"
      leaves[my_index-1].element += number
    end

    def top_level_ancestor
      return self unless self.ancestor

      top_ancestor = self.ancestor
      top_ancestor = top_ancestor.ancestor while top_ancestor.ancestor
      top_ancestor
    end

    # @return [Array<Tree>] the list of all trees of level one, correctly ordered
    def all_leaves
      # puts "Finding mini trees of #{self} (heigh: #{height})"
      return [self] if height == 0

      @subtrees.flat_map(&:all_leaves)
    end

    def split?
      @subtrees.any?(&:split?)
    end

    def split!
      leaves = top_level_ancestor.all_leaves
      splitable = leaves.find(&:split?)
      # puts "Will split leave of #{splitable.ancestor}"
      left = (splitable.element * 0.5).truncate.to_i
      right = (splitable.element * 0.5).ceil.to_i
      splitable.replace!(Tree.new([Leaf.new(left), Leaf.new(right)]))
    end
  end

  class Leaf < Tree
    def initialize(element)
      @element = element
    end

    def magnitude
      @element
    end

    attr_accessor :element
    def height
      0
    end
    alias_method :update_height!, :height
    def split?
      @element >= 10
    end

    def to_a
      @element
    end

    def dup
      Leaf.new(element)
    end
  end

end

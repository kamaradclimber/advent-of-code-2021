#!/usr/bin/env ruby

class Day12
  def initialize(input)
    @edges = Hash.new { |h, key| h[key] = [] }
    input.split("\n").map do |edge_string|
      a, b = edge_string.split('-')
      @edges[a] << b
      @edges[b] << a
    end
  end

  def run_part1
    complete_paths = []
    to_explore = []
    path = Path.new
    path << 'start'
    to_explore << path
    while to_explore.any?
      path = to_explore.pop
      @edges[path.current_loc].each do |cave|
        next if path.visited_small_caves.include?(cave)

        new_path = path.dup
        new_path << cave
        if cave == 'end'
          complete_paths << new_path
        else
          to_explore << new_path
        end
      end
    end
    complete_paths.size
  end

  def run_part2
    raise NotImplementedError
  end

  class Path
    def initialize(path = [])
      @visited_small_caves = []
      @path = path
    end

    def <<(cave)
      @path << cave
      @visited_small_caves << cave if cave.downcase == cave
      self
    end

    def to_s
      @path.join('->')
    end

    def current_loc
      @path.last
    end

    attr_accessor :visited_small_caves

    def dup
      new_path = Path.new(@path.dup)
      new_path.visited_small_caves = visited_small_caves.dup
      new_path
    end
  end
end

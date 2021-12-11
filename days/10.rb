#!/usr/bin/env ruby

class Day10
  def initialize(input)
    @input = input.split("\n").map(&:chars)
  end

  def run_part1
    points = { ')' => 3, ']' => 57, '}' => 1197, '>' => 25_137 }
    @input.map do |chars|
      _stack, invalid = check_syntax(chars)
      points[invalid] if invalid
    end.compact.sum
  end

  # @return [Array<(Array<String>, String)>] return the current stack and the invalid char
  def check_syntax(chars)
    matching = { ')' => '(', ']' => '[', '>' => '<', '}' => '{' }
    stack = []
    chars.each do |char|
      case char
      when '(', '{', '[', '<'
        stack << char
      else
        return [stack, char] if stack.last != matching[char]

        stack.pop
      end
    end
    [stack, nil]
  end

  def run_part2
    scores = []
    @input.each do |chars|
      stack, invalid = check_syntax(chars)
      next if invalid

      # otherwise let's complete the stack and count the score
      score = 0
      while (char = stack.pop)
        closing_scores = { '(' => 1, '[' => 2, '{' => 3, '<' => 4 }
        score = score * 5 + closing_scores[char]
      end
      scores << score
    end
    scores.sort[scores.size / 2]
  end
end

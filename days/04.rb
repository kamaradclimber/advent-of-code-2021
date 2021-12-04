#!/usr/bin/env ruby

class Day04
  def initialize(input)
    lines = input.split("\n")
    @numbers = lines.first.split(',').map(&:to_i)
    @cards = lines[1..-1].each_slice(6).map do |card_input|
      BingoCard.new(card_input[1..-1])
    end
  end

  def run_part1
    @numbers.each do |new_number|
      @cards.each_with_index do |card, card_index|
        if card.mark(new_number)
          # card is now winning
          return card.score(new_number)
        end
      end
    end
  end

  def run_part2
    @numbers.each do |new_number|
      @cards.each_with_index do |card, card_index|
        next if card.bingo?

        if card.mark(new_number)
          # card is now winning
          if @cards.all?(&:bingo?)
            return card.score(new_number)
          end
        end
      end
    end
  end

  class BingoCard
    def initialize(lines)
      @numbers = lines.map { |l| l.strip.split(/ +/).map(&:to_i) }
      @marks = @numbers.size.times.map { [false] * @numbers.first.size }
    end

    # @return [Boolean] true if bingo card is winning
    def bingo?
      @bingo ||= @marks.any? { |line| line.all?(&:itself) } || @marks.transpose.any? { |line| line.all?(&:itself) }
    end

    # @return [Integer] score of the bingo card
    def score(winning_number)
      score = 0
      @numbers.each_with_index do |line, i|
        line.each_with_index do |card_number, j|
          score += card_number unless @marks[i][j]
        end
      end
      score * winning_number
    end

    # @return [Boolean] true if bingo card is winning
    def mark(number)
      @numbers.each_with_index do |line, i|
        line.each_with_index do |card_number, j|
          if card_number == number
            @marks[i][j] = true
            return bingo?
          end
        end
      end
      false
    end
  end
end

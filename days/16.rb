#!/usr/bin/env ruby

module Day16Extension
  def equal_to
    raise 'Only works with 2 subpackets' if size != 2

    a, b = self
    a == b ? 1 : 0
  end

  def lower_than
    raise 'Only works with 2 subpackets' if size != 2

    a, b = self
    a < b ? 1 : 0
  end

  def greater_than
    raise 'Only works with 2 subpackets' if size != 2

    a, b = self
    a > b ? 1 : 0
  end

  def day16_product
    reduce(&:*)
  end
end

class Array
  include Day16Extension
end

class Day16
  def initialize(input)
    @input_bits = input.chars.map{format('%04b', _1.to_i(16))}.join('')
    @i = 0
    @depth = 0
  end
  attr_reader :i

  def run_part1
    @part1 = true
    parse_one_packet
  end

  def log(message)
    return unless ENV['DEBUG']

    leading_spaces = '  ' * @depth
    puts(leading_spaces + message)
  end

  # @param [Integer] index to start parsing from
  # @param [Integer] max length to parse
  # @return a packet
  def parse_one_packet
    version = @input_bits[i..i + 2].to_i(2)
    @i += 3
    type = @input_bits[i..i + 2].to_i(2)
    @i += 3
    case type
    when 4
      @depth += 1
      value = litteral_value
      @depth -= 1
      log "Find packet of type #{type} (litteral: #{value}), version #{version}"
      if @part1
        version
      else
        value
      end
    else
      length_type_id = @input_bits[i]
      @i += 1
      subresults = []
      operator = case type
                 when 0
                   :sum
                 when 1
                   :day16_product
                 when 2
                   :min
                 when 3
                   :max
                 when 5
                   :greater_than
                 when 6
                   :lower_than
                 when 7
                   :equal_to
                 end
      operator = :sum if @part1
      case length_type_id
      when '0'
        subpackets_length = @input_bits[i..i + 14].to_i(2)
        @i += 15
        log "an operator (#{operator}) packet (version #{version}) (type length of subpackets #{subpackets_length}), which contains"
        max_index = i + subpackets_length
        while i < max_index
          @depth += 1
          subresults << parse_one_packet
          @depth -= 1
        end
      when '1'
        subpacket_count = @input_bits[i..i + 10].to_i(2)
        @i += 11
        log "an operator (#{operator}) packet (version #{version}) (type count of subpackets #{subpacket_count}), which contains"
        subpacket_count.times do
          @depth += 1
          subresults << parse_one_packet
          @depth -= 1
        end
      else
        raise "Unknown length_type_id '#{length_type_id}'"
      end
      subresult = subresults.send(operator)
      subresult += version if @part1
      subresult
    end
  end

  # @return [Integer] the litteral value
  def litteral_value
    litteral = 0
    continuation = true
    while continuation
      continuation = @input_bits[i] == '1'
      litteral += @input_bits[i + 1..i + 4].to_i(2)
      litteral *= 2**4 if continuation
      @i += 5
    end
    litteral
  end

  def run_part2
    parse_one_packet
  end
end

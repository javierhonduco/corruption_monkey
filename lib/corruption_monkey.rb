require 'logger'

module BitFlipper
  BitOutOfBounds = Class.new(Exception)

  def self.flip!(target, bit:, logger: Logger.new(nil))
    logger.debug "going to flip bit with index=#{bit}"

    flip_byte, flip_bit = bit.divmod(8)

    logger.debug "computed [byte, bit]=#{[flip_byte, flip_bit]}"

    file = File.open(target, 'r+')

    file.seek(flip_byte, 0)
    byte = file.read(1)

    if byte.nil? || out_of_range(target, bit)
      raise BitOutOfBounds, "#{bit} is bigger than the offset=#{size_in_bits(target)}"
    end

    new_byte = [byte.unpack('c').first ^ (1 << flip_bit)].pack('c')

    logger.debug "readed byte: `#{byte}`: #{byte.unpack('b*').first}"
    logger.debug "writing byte: `#{new_byte}` #{new_byte.unpack('b*').first}"

    file.seek(-1, IO::SEEK_CUR)
    file.write(new_byte)

    file.fsync
    file.close
  end

  def self.random_bit_flip(target, logger: Logger.new(nil))
    computed_bit = rand(0...size_in_bits(target))
    flip!(target, bit: computed_bit, logger: logger)
  end

  def self.flip_in_range(target, percentile:, logger: Logger.new(nil))
    # TODO(javierhonduco): Improve error checking (╯ರ ~ ರ)
    bit_to_flip = (size_in_bits(target) * percentile / 101.0).to_i

    if out_of_range(target, bit_to_flip)
      raise IndexError, "percentile=#{percentile} not in range"
    end

    flip!(target, bit: bit_to_flip, logger: logger)
  end

  def self.size_in_bits(file)
    File.size(file) * 8
  end

  def self.out_of_range(file, bit)
    bit < 0 || bit > size_in_bits(file)
  end
end

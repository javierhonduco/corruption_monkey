module TestHelpers
  ProcessExecutionError = Class.new(Exception)

  def zeroes(file)
    `dd if=/dev/zero of=#{file} bs=1 count=10 2> /dev/null`
    raise ProcessExecutionError unless $?.success?
  end

  def hamming_weight(file)
    File.read(file).
      unpack('b*').
      first.
      split(//).
      map { |b| b == '1' }.
      count(true)
  end
end

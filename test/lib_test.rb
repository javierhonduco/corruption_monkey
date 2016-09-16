require 'minitest/autorun'
require 'fileutils'
require 'corruption_monkey'
require_relative 'test_helpers'

class TestBitFlipper < Minitest::Test
  include TestHelpers

  TEST_DIR = "/tmp/bit_flipper_monkey_test_#{rand(0..999)}"

  def setup
    FileUtils.rm_rf(TEST_DIR) # Ensure clean state
    FileUtils.mkdir(TEST_DIR)
  end

  def teardown
    FileUtils.rm_rf(TEST_DIR)
  end

  def test_number_of_changed_bits
    test_file = "#{TEST_DIR}/zeroes"
    zeroes(test_file)

    BitFlipper.flip!(test_file, bit: 0)
    assert_equal 1, hamming_weight(test_file)

    BitFlipper.flip!(test_file, bit: 1)
    assert_equal 2, hamming_weight(test_file)
  end

  def test_basic_ascii_mathz
    test_file = "#{TEST_DIR}/simple_ascii"

    File.open(test_file, 'w') do |f|
      f.write 'a'
    end

    BitFlipper.flip!(test_file, bit: 0)
    BitFlipper.flip!(test_file, bit: 1)
    assert_equal 'b', File.read(test_file)
  end

  def test_basic_zeroes
    test_file = "#{TEST_DIR}/zeroes"
    zeroes(test_file)

    BitFlipper.flip!(test_file, bit: 9)
    assert_equal "\u0000\u0002#{"\u0000" * 8}", File.read(test_file)
  end

  def test_twice_flipped_bit
    test_file = "#{TEST_DIR}/zeroes"
    base_file = "#{TEST_DIR}/zeroes_DO_NOT_MODIFY"

    [test_file, base_file].each do |file|
      zeroes(file)
    end

    BitFlipper.flip!(test_file, bit: 5)
    BitFlipper.flip!(test_file, bit: 5)
    assert_equal File.read(base_file), File.read(test_file)

    BitFlipper.flip!(test_file, bit: 2)
    BitFlipper.flip!(test_file, bit: 2)
    assert_equal File.read(base_file), File.read(test_file)
  end

  def test_percentage
    test_file = "#{TEST_DIR}/zeroes"
    zeroes(test_file)

    BitFlipper.flip_in_range(test_file, percentile: 0)
    assert_equal "\u0001#{"\u0000" * 9}", File.read(test_file)
    zeroes(test_file)

    BitFlipper.flip_in_range(test_file, percentile: 50)
    assert_equal "#{"\u0000" * 4}\x80#{"\u0000" * 5}", File.read(test_file)
    zeroes(test_file)

    BitFlipper.flip_in_range(test_file, percentile: 100)
    assert_equal "#{"\u0000" * 9}\x80", File.read(test_file)
  end

  def test_bit_out_of_bounds_error
    test_file = "#{TEST_DIR}/ascii_out_of_bounds"

    File.open(test_file, 'w') do |f|
      f.write 'a'
    end

    assert_raises BitFlipper::BitOutOfBounds do
      BitFlipper.flip!(test_file, bit: 10)
    end
  end

  def test_random_bit_flip
    test_file = "#{TEST_DIR}/zeroes"
    zeroes(test_file)

    BitFlipper.random_bit_flip(test_file)
    assert_equal 1, hamming_weight(test_file)
  end
end

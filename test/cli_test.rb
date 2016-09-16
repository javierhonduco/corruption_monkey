require 'minitest/autorun'
require 'fileutils'
require 'corruption_monkey'
require_relative 'test_helpers'

class TestCLI < Minitest::Test
  include TestHelpers

  TEST_DIR = "/tmp/bit_flipper_monkey_test_cli_#{rand(0..999)}"

  def setup
    FileUtils.rm_rf(TEST_DIR) # Ensure clean state
    FileUtils.mkdir(TEST_DIR)
  end

  def teardown
    FileUtils.rm_rf(TEST_DIR)
  end

  def test_accurate_bit_flip
    test_file = "#{TEST_DIR}/zeroes"
    zeroes(test_file)

    run_cli(test_file, '9')
    assert_equal "\u0000\u0002#{"\u0000" * 8}", File.read(test_file)
  end

  def test_accurate_percentage_flip
    test_file = "#{TEST_DIR}/zeroes"
    zeroes(test_file)

    run_cli(test_file, '0%')
    assert_equal "\u0001#{"\u0000" * 9}", File.read(test_file)
  end

  def test_random_bit_flip
    test_file = "#{TEST_DIR}/zeroes"
    zeroes(test_file)

    run_cli(test_file, 'chaos')
    assert_equal 1, hamming_weight(test_file)
  end

  def test_help
    run_cli =~ /CLI options:/
    run_cli('help') =~ /CLI options:/
  end

  private

  def run_cli(*args)
    output = `bin/flip #{args * ' '}`
    raise ProcessExecutionError unless $?.success?
    output
  end
end

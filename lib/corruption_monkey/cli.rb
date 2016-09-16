require 'corruption_monkey'

module BitFlipper::CLI
  DOCS = <<-DOCS
  CLI options:

    1. Specific bit flip (by absolute or relative indexing)
      $ flip <file_path> (<bit_index>|<percentage of file>%)

    2. Chaos mode (randomized)
      $ flip <file_path> chaos

  To display help:
    $ flip help
  DOCS

  def self.banner(s = $stdout)
    s.puts '🔥 🔥 🔥 🔥 🔥 🔥 🔥 🔥 🔥 🔥 🔥 🔥 🔥 🔥 '
    s.puts '🔥 bit flipper chaos 🙈  CLI🔥'
    s.puts '🔥 🔥 🔥 🔥 🔥 🔥 🔥 🔥 🔥 🔥 🔥 🔥 🔥 🔥 '
    s.puts
  end

  def self.start(args = ARGV)
    file_path = args.shift
    second_argument = args.shift

    # Empty imput or docs request
    if (file_path.nil? && second_argument.nil?) ||
        (!File.file?(file_path) && file_path == 'help')
      puts DOCS
      exit 0
    end

    # First argument is not a (existing) file
    unless File.file?(file_path)
      $stderr.puts "The file with path=`#{file_path}` does not exist"
      exit 1
    end

    logger = Logger.new(STDOUT)
    banner

    case second_argument
    when 'chaos'
      puts 'chaos mode selected'
      puts
      BitFlipper.random_bit_flip(file_path, logger: logger)
    when /([0-9]{1, 2}|100)%/
      # this regex feels... weird
      puts 'percent mode selected'
      puts
      BitFlipper.flip_in_range(file_path,
                               percentile: second_argument.to_i,
                               logger: logger)
    when /[0-9]+/
      puts 'accurate mode selected'
      puts
      BitFlipper.flip!(file_path,
                       bit: second_argument.to_i,
                       logger: logger)
    else
      $stderr.puts 'nothing matches!'
      $stderr.puts DOCS
    end
  end
end

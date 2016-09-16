$LOAD_PATH << 'lib'
require 'corruption_monkey/version'

Gem::Specification.new do |gem|
  gem.authors       = %w(Javier Honduvilla Coto)
  gem.email         = %w(javier.honduvilla@shopify.com javierhonduco@gmail.com)
  gem.description   = 'Bit flipping tool.'
  gem.summary       = 'Library and CLI to flip a bit in a provided file.'
  gem.homepage      = 'https://github.com/Shopify/corruption_monkey'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^test/})
  gem.name          = 'corruption_monkey'
  gem.require_paths = ['lib']

  gem.version       = BitFlipper::VERSION
end

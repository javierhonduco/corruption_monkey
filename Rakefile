require 'rake/testtask'
require 'bundler/setup'
require 'bundler/gem_tasks'

task default: :test

Rake::TestTask.new do |t|
  t.test_files = FileList['test/*test.rb']
end

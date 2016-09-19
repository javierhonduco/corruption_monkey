require 'rake/testtask'
require 'bundler/setup'
require 'bundler/gem_tasks'
require 'rubocop/rake_task'

task default: [:rubocop, :test]

RuboCop::RakeTask.new
Rake::TestTask.new do |t|
  t.test_files = FileList['test/*test.rb']
end

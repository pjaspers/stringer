#!/usr/bin/env rake
require "bundler/gem_tasks"
require 'rake/testtask'

desc 'Run the specs'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'specs'
  t.pattern = 'specs/**/*_spec.rb'
  t.verbose = false
end

task :default => :test

desc "Open an pry session with Stringer loaded"
task :console do
  sh "pry -I lib -r stringer.rb"
end

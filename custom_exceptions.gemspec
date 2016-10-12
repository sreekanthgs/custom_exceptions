$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'custom_exceptions'

Gem::Specification.new do |s|
  s.name = 'custom_exceptions'
  s.summary = 'CustomExceptions generates custom exception classes to be used in Ruby or RubyonRails'
  s.description = 'CustomExceptions allows generation of custom exception classes from yaml config files or at runtime to be used in Ruby or RubyonRails'
  s.email = 'mail@sreekanth.in'
  s.homepage = 'http://github.com/sreekanthgs/custom_exceptions'
  s.authors = ['Sreekanth GS']
  s.version = CustomExceptions::VERSION
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rdoc'
  s.files = Dir['lib/**/*.rb']
end

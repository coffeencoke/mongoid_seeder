# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mongoid_seeder/version'

Gem::Specification.new do |spec|
  spec.name          = "mongoid_seeder"
  spec.version       = MongoidSeeder::VERSION
  spec.authors       = ["Matt Simpson", "Cameron Mauch", "Asynchrony"]
  spec.email         = ["matt.simpson3@gmail.com", "cam@douglas-cameron.net"]
  spec.description   = "Helps with seeding data with mongoid"
  spec.summary       = "Helps with seeding data with mongoid"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake", "~> 10.1"

  spec.add_dependency 'mongoid', "~> 3.1"
  spec.add_dependency 'mongoid-shell', "0.2.0"
end

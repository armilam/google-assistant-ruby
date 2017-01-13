# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "google_assistant/version"

Gem::Specification.new do |spec|
  spec.name          = "google_assistant"
  spec.version       = GoogleAssistant::VERSION
  spec.authors       = ["Aaron Milam"]
  spec.email         = ["armilam@gmail.com"]

  spec.summary       = "Ruby SDK for the Google Assistant API"
  spec.description   = "This SDK provides the framework for creating Google Assistant actions in Ruby. It works in Ruby on Rails and Sinatra (and probably others)."
  spec.homepage      = "https://github.com/armilam/google-assistant-ruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end

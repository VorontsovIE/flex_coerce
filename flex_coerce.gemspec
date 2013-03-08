# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'flex_coerce/version'

Gem::Specification.new do |spec|
  spec.name          = "flex_coerce"
  spec.version       = FlexCoerce::VERSION
  spec.authors       = ["Ilya Vorontsov"]
  spec.email         = ["prijutme4ty@gmail.com"]
  spec.description   = %q{FlexCoerce - is a gem which allow you create operator-dependent coercion logic. It's useful when your type should be treated in a different way for different binary operations (including arithmetic operators, bitwise operators and comparison operators except equality checks: `==`, `===`).}
  spec.summary       = %q{FlexCoerce - is a gem which allow you create operator-dependent coercion logic. It's useful when your type should be treated in a different way for different binary operations (including arithmetic operators, bitwise operators and comparison operators except equality checks: `==`, `===`).}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'rspec', '>= 2.0'
  spec.add_development_dependency 'rspec-given', '>= 2.0.0'
  
  spec.required_ruby_version = '2.0.0'
end

# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hyper_mapper/version'

Gem::Specification.new do |gem|
  gem.name          = "HyperMapper"
  gem.version       = HyperMapper::VERSION
  gem.authors       = ["Matt Goggin"]
  gem.email         = ["goggin13@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'activerecord', '~> 3.2.11'
  gem.add_dependency 'activesupport', '~> 3.2.11'
  gem.add_dependency 'activemodel', '~> 3.2.11'
  gem.add_development_dependency 'rspec', '~> 2.12'
end

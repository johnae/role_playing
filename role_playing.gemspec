# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'role_playing/version'

Gem::Specification.new do |gem|
  gem.name          = "role_playing"
  gem.version       = RolePlaying::VERSION
  gem.authors       = ["John Axel Eriksson"]
  gem.email         = ["john@insane.se"]
  gem.description   = %q{A ruby DCI implementation}
  gem.summary       = %q{A ruby DCI implementation}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency("rspec", ">= 2.12.0")
  gem.add_development_dependency("bundler", "~> 1.2.0")

  gem.add_dependency("activesupport", ">= 3.0.0")
end

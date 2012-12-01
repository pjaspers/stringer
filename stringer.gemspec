# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'stringer/version'

Gem::Specification.new do |gem|
  gem.name          = "stringer"
  gem.version       = Stringer::VERSION
  gem.authors       = ["pjaspers"]
  gem.email         = ["piet@jaspe.rs"]
  gem.description   = %q{Stringer: a wrapper for genstrings}
  gem.summary       = %q{Stringer adds merging capabilities to genstrings}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|specs|features)/})
  gem.require_paths = ["lib"]
end

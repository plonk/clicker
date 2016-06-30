# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'clicker/version'

Gem::Specification.new do |spec|
  spec.name          = "clicker"
  spec.version       = Clicker::VERSION
  spec.authors       = ["Yoteichi"]
  spec.email         = ["plonk@piano.email.ne.jp"]

  spec.summary       = %q{clicker makes your keyboard go clickety-clack.}
  spec.description   = %q{clicker makes your keyboard go clickety-clack.}
  spec.homepage      = "https://github.com/plonk/clicker"
  spec.licenses      = "GPL-2"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rubysdl", "~> 2.2.0"
  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end

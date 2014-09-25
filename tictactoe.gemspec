lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tictactoe/version'

Gem::Specification.new do |spec|
  spec.name          = "tictactoe"
  spec.version       = Tictactoe::VERSION
  spec.authors       = ["Christoph Gockel"]
  spec.email         = ["github@christophgockel.de"]
  spec.summary       = %q{Tic Tac Toe gem}
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/christophgockel/tictactoe-gem"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.require_paths = ["lib", "spec/helpers"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end

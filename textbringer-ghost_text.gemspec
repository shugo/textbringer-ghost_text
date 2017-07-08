# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'textbringer/ghost_text/version'

Gem::Specification.new do |spec|
  spec.name          = "textbringer-ghost_text"
  spec.version       = Textbringer::GhostText::VERSION
  spec.authors       = ["Shugo Maeda"]
  spec.email         = ["shugo@ruby-lang.org"]

  spec.summary       = "GhostText plugin for Textbringer."
  spec.description   = "GhostText plugin for Textbringer."
  spec.homepage      = "https://github.com/shugo/textbringer-ghost_text"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "textbringer", ">= 0.2.5"
  spec.add_runtime_dependency "thin"
  spec.add_runtime_dependency "faye-websocket"

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 12.0"
end

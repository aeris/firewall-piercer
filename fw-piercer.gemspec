# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'firewall_piercer/version'

Gem::Specification.new do |spec|
  spec.name          = 'fw-piercer'
  spec.version       = FirewallPiercer::VERSION
  spec.authors       = %w(Aeris)
  spec.email         = %w(aeris@imirhil.fr)
  spec.summary       = %q{}
  spec.description   = %q{}
  spec.homepage      = ''
  spec.license       = 'GPLv3+'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = %w(lib)

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
end

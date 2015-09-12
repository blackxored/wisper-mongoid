# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wisper/mongoid/version'

Gem::Specification.new do |spec|
  spec.name          = 'wisper-mongoid'
  spec.version       = Wisper::Mongoid::VERSION
  spec.authors       = ['Adrian Perez']
  spec.email         = ['adrianperez.deb@gmail.com']
  spec.summary       = 'Subscribe to changes on Mongoid models'
  spec.description   = 'Subscribe to changes on Mongoid models'
  spec.homepage      = 'https://github.com/blackxored/wisper-mongoid'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 1.9.3'

  spec.add_dependency 'wisper', '~> 1.3'
  spec.add_dependency 'mongoid', '~> 5'
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "simplecov"
end

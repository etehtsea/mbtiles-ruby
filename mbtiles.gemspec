# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mbtiles/version'

Gem::Specification.new do |spec|
  spec.name          = 'mbtiles'
  spec.version       = MBTiles::VERSION
  spec.authors       = ['Konstantin Shabanov']
  spec.email         = ['etehtsea@gmail.com']
  spec.description   = %q{MBTiles reader/writer}
  spec.summary       = %q{MBTiles reader/writer}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency             'sqlite3'
  spec.add_dependency             'sequel'
  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'minitest', '~> 4.0'
  spec.add_development_dependency 'turn'
  spec.add_development_dependency 'pry'
end

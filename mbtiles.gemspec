# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mbtiles/version'

Gem::Specification.new do |spec|
  spec.name          = 'mbtiles'
  spec.version       = MBTiles::VERSION
  spec.authors       = ['Konstantin Shabanov', 'Aleksey Magusev']
  spec.email         = ['etehtsea@gmail.com', 'lexmag@gmail.com']
  spec.description   = %q{MBTiles reader/writer. Based on mbtiles-spec v1.1}
  spec.summary       = %q{MBTiles reader/writer}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency (RUBY_PLATFORM == 'java' ? 'jdbc-sqlite3' : 'sqlite3')
  spec.add_dependency 'sequel', '>= 4.1.0'
  spec.add_dependency 'faraday'
  spec.add_dependency 'typhoeus'
  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'minitest', '~> 4.0'
  spec.add_development_dependency 'turn'
  spec.add_development_dependency 'pry'
end

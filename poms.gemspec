# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'poms/version'
require 'rake'

Gem::Specification.new do |spec|
  spec.name          = "poms"
  spec.version       = Poms::VERSION
  spec.authors       = ["Tom Kruijsen", "Stijn Meurkens", "Tijn Schuurmans"]
  spec.email         = ["tom@brightin.nl", "stijn@brightin.nl", "tijn@brightin.nl"]
  spec.description   = %q{Interface to POMS CouchDB API}
  spec.summary       = %q{Interfcae to POMS CouchDB API}
  spec.homepage      = "https://github.com/brightin/poms"
  spec.license       = "MIT"

  spec.files         = FileList['lib/**/*.rb',  '[A-Z]*', 'spec/**/*'].to_a
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "fakeweb"
  spec.add_development_dependency "fabrication"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "timecop"
  spec.add_development_dependency "vcr"
  spec.add_dependency "activesupport"
end

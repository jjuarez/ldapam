# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$:<< lib unless $LOAD_PATH.include?(lib)
require 'ldapam/version'

Gem::Specification.new do |spec|

  spec.name          = "ldapam"
  spec.version       = LDAPAM::VERSION
  spec.authors       = ["Javier Juarez"]
  spec.email         = ["javier.juarez@gmail.com"]
  spec.summary       = %q{Utilidad para modificacion de campos LDAP}
  spec.description   = %q{Utilidad para la gestion de los códigos de ubicación de usuarios en el CSIC}
  spec.homepage      = "http://www.csic.es"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "net-ldap", "~> 0.5"
  spec.add_dependency "thor", "0.18"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "irbtools"
end

# -*- encoding: utf-8 -*-
require File.expand_path('../lib/doc_juans_helper/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Joel Junström"]
  gem.email         = ["joel.junstrom@oktavilla.se"]
  gem.description   = %q{A small helper class to generate urls to a Doc-Juan instance}
  gem.summary       = %q{Given a url and options the DocJuansHelper generates a url to a DocJuan server including the calculated hmac key}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "doc_juans_helper"
  gem.require_paths = ["lib"]
  gem.version       = DocJuansHelper::VERSION
end

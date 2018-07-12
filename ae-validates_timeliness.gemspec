# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ae-validates_timeliness/version"

Gem::Specification.new do |s|
  s.name        = "ae-validates_timeliness"
  s.version     = ValidatesTimeliness::VERSION
  s.authors     = ["Paul Kmiec"]
  s.summary     = %q{Date and time validation plugin for Rails which allows custom formats}
  s.description = %q{Adds validation methods to ActiveModel for validating dates and times. Works with multiple ORMS.}
  s.email       = %q{paul.kmiec@appfolio.com}
  s.homepage    = %q{http://github.com/appfolio/validates_timeliness}

  s.files         = Dir['**/*'].reject{ |f| f[%r{^pkg/}] || f[%r{^spec/}] }
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency(%q<rails>, [">= 4.0", "< 5.3"])
  s.add_runtime_dependency(%q<timeliness>, ["~> 0.3.7"])

  s.add_development_dependency "coveralls"
  s.add_development_dependency "rspec", "~> 3.0"
  s.add_development_dependency "rspec-rails", "~> 3.0"
  s.add_development_dependency "rspec-collection_matchers"
end

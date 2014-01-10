# -*- encoding: utf-8 -*-
require './lib/opi/version'

Gem::Specification.new do |s|
  s.name = %q{opi}
  s.version = Opi::VERSION
  s.platform = Gem::Platform::RUBY

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Richard Taylor"]
  s.date = %q{2014-01-10}
  s.description = %q{The very opinionated API service library.}
  s.email = %q{moomerman@gmail.com}
  s.files = ["README.md", "LICENSE", "lib/opi.rb"] + Dir.glob('lib/opi/*.rb')
  s.has_rdoc = false
  s.homepage = %q{http://github.com/moomerman/opi}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{opi}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{The very opinionated API service library.}

  s.add_runtime_dependency(%q<rack>, [">= 1.5.2"])
  s.add_runtime_dependency(%q<colored>, [">= 1.2"])
  s.add_runtime_dependency(%q<json>, [">= 1.8.1"])
  s.add_runtime_dependency(%q<mutations>, [">= 0.6.0"])
end

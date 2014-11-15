# -*- encoding: utf-8 -*-
require './lib/opi/version'

Gem::Specification.new do |s|
  s.name = %q{opi}
  s.version = Opi::VERSION
  s.platform = Gem::Platform::RUBY

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Richard Taylor"]
  s.date = %q{2014-10-21}
  s.description = %q{A Ruby library for creating API services.  The very opinionated API service library.}
  s.email = %q{moomerman@gmail.com}
  s.files = ["README.md", "LICENSE", "lib/opi.rb"] + Dir.glob('lib/opi/*.rb')
  s.has_rdoc = false
  s.homepage = %q{http://github.com/moomerman/opi}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{The very opinionated API service library.}
  s.license = 'MIT'
  s.rubyforge_project = 'opi'

  s.add_runtime_dependency 'rack', '~> 1.5', '>= 1.5.2'
  s.add_runtime_dependency 'colored', '~> 1.2'
  s.add_runtime_dependency 'multi_json'

  s.add_development_dependency 'rack-test'
  s.add_development_dependency 'rspec', '~> 3.0'
  s.add_development_dependency 'rake'
end

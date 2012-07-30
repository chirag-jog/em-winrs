# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "em-winrs/version"

Gem::Specification.new do |s|
  s.name        = "em-winrs"
  s.version     = EventMachine::WinRS::VERSION
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.rdoc", "LICENSE" ]
  s.authors     = ["Chirag Jog"]
  s.email       = ["chirag.jog@gmail.com"]
  s.homepage    = "http://github.com/chirag-jog/em-winrs"
  s.summary     = %q{EventMachine based, asynchronous parallel WinRS client}
  s.description = s.summary

  s.required_ruby_version	= '>= 1.9.1'
  s.add_dependency "eventmachine", "= 1.0.0.beta.3"
  s.add_dependency "mixlib-log", ">= 1.3.0"
  s.add_dependency "uuidtools", "~> 2.1.1"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end

# -*- encoding: utf-8 -*-
# stub: codeclimate-engine-rb 0.3.1 ruby lib

Gem::Specification.new do |s|
  s.name = "codeclimate-engine-rb"
  s.version = "0.3.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Andy Waite"]
  s.bindir = "exe"
  s.date = "2016-01-24"
  s.email = ["github.aw@andywaite.com"]
  s.homepage = "https://github.com/andyw8/codeclimate-engine-rb"
  s.rubygems_version = "2.4.5.1"
  s.summary = "JSON issue formatter for the Code Climate engine"

  s.installed_by_version = "2.4.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>, ["~> 1.9"])
      s.add_development_dependency(%q<rake>, ["~> 10.0"])
      s.add_development_dependency(%q<rspec>, ["~> 3.3"])
      s.add_runtime_dependency(%q<virtus>, ["~> 1.0"])
    else
      s.add_dependency(%q<bundler>, ["~> 1.9"])
      s.add_dependency(%q<rake>, ["~> 10.0"])
      s.add_dependency(%q<rspec>, ["~> 3.3"])
      s.add_dependency(%q<virtus>, ["~> 1.0"])
    end
  else
    s.add_dependency(%q<bundler>, ["~> 1.9"])
    s.add_dependency(%q<rake>, ["~> 10.0"])
    s.add_dependency(%q<rspec>, ["~> 3.3"])
    s.add_dependency(%q<virtus>, ["~> 1.0"])
  end
end

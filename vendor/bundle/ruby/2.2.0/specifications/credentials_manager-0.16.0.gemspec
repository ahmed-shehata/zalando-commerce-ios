# -*- encoding: utf-8 -*-
# stub: credentials_manager 0.16.0 ruby lib

Gem::Specification.new do |s|
  s.name = "credentials_manager"
  s.version = "0.16.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Felix Krause"]
  s.date = "2016-04-22"
  s.description = "Password manager used in fastlane.tools"
  s.email = ["fastlane@krausefx.com"]
  s.executables = ["fastlane-credentials"]
  s.files = ["bin/fastlane-credentials"]
  s.homepage = "https://fastlane.tools"
  s.licenses = ["MIT"]
  s.required_ruby_version = Gem::Requirement.new(">= 2.0.0")
  s.rubygems_version = "2.4.5.1"
  s.summary = "Password manager used in fastlane.tools"

  s.installed_by_version = "2.4.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<colored>, [">= 0"])
      s.add_runtime_dependency(%q<commander>, [">= 4.3.5"])
      s.add_runtime_dependency(%q<highline>, [">= 1.7.1"])
      s.add_runtime_dependency(%q<security>, [">= 0"])
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<pry>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 3.1.0"])
      s.add_development_dependency(%q<rspec_junit_formatter>, ["~> 0.2.3"])
      s.add_development_dependency(%q<webmock>, ["~> 1.19.0"])
      s.add_development_dependency(%q<coveralls>, [">= 0"])
      s.add_development_dependency(%q<fastlane>, [">= 0"])
      s.add_development_dependency(%q<rubocop>, ["~> 0.38.0"])
    else
      s.add_dependency(%q<colored>, [">= 0"])
      s.add_dependency(%q<commander>, [">= 4.3.5"])
      s.add_dependency(%q<highline>, [">= 1.7.1"])
      s.add_dependency(%q<security>, [">= 0"])
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<pry>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 3.1.0"])
      s.add_dependency(%q<rspec_junit_formatter>, ["~> 0.2.3"])
      s.add_dependency(%q<webmock>, ["~> 1.19.0"])
      s.add_dependency(%q<coveralls>, [">= 0"])
      s.add_dependency(%q<fastlane>, [">= 0"])
      s.add_dependency(%q<rubocop>, ["~> 0.38.0"])
    end
  else
    s.add_dependency(%q<colored>, [">= 0"])
    s.add_dependency(%q<commander>, [">= 4.3.5"])
    s.add_dependency(%q<highline>, [">= 1.7.1"])
    s.add_dependency(%q<security>, [">= 0"])
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<pry>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 3.1.0"])
    s.add_dependency(%q<rspec_junit_formatter>, ["~> 0.2.3"])
    s.add_dependency(%q<webmock>, ["~> 1.19.0"])
    s.add_dependency(%q<coveralls>, [">= 0"])
    s.add_dependency(%q<fastlane>, [">= 0"])
    s.add_dependency(%q<rubocop>, ["~> 0.38.0"])
  end
end

# -*- encoding: utf-8 -*-
# stub: jazzy 0.7.0 ruby lib
# stub: lib/jazzy/SourceKitten/Rakefile

Gem::Specification.new do |s|
  s.name = "jazzy"
  s.version = "0.7.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["JP Simard", "Tim Anglade", "Samuel Giddins"]
  s.date = "2016-06-12"
  s.description = "Soulful docs for Swift & Objective-C. Run in your Xcode project's root directory for instant HTML docs."
  s.email = ["jp@realm.io"]
  s.executables = ["jazzy"]
  s.extensions = ["lib/jazzy/SourceKitten/Rakefile"]
  s.files = ["bin/jazzy", "lib/jazzy/SourceKitten/Rakefile"]
  s.homepage = "http://github.com/realm/jazzy"
  s.licenses = ["MIT"]
  s.required_ruby_version = Gem::Requirement.new(">= 2.0.0")
  s.rubygems_version = "2.4.5.1"
  s.summary = "Soulful docs for Swift & Objective-C."

  s.installed_by_version = "2.4.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<cocoapods>, ["~> 1.0"])
      s.add_runtime_dependency(%q<mustache>, ["~> 0.99"])
      s.add_runtime_dependency(%q<open4>, [">= 0"])
      s.add_runtime_dependency(%q<redcarpet>, ["~> 3.2"])
      s.add_runtime_dependency(%q<rouge>, ["~> 1.5"])
      s.add_runtime_dependency(%q<sass>, ["~> 3.4"])
      s.add_runtime_dependency(%q<sqlite3>, ["~> 1.3"])
      s.add_runtime_dependency(%q<xcinvoke>, ["~> 0.2.1"])
      s.add_development_dependency(%q<bundler>, ["~> 1.7"])
      s.add_development_dependency(%q<rake>, ["~> 10.3"])
    else
      s.add_dependency(%q<cocoapods>, ["~> 1.0"])
      s.add_dependency(%q<mustache>, ["~> 0.99"])
      s.add_dependency(%q<open4>, [">= 0"])
      s.add_dependency(%q<redcarpet>, ["~> 3.2"])
      s.add_dependency(%q<rouge>, ["~> 1.5"])
      s.add_dependency(%q<sass>, ["~> 3.4"])
      s.add_dependency(%q<sqlite3>, ["~> 1.3"])
      s.add_dependency(%q<xcinvoke>, ["~> 0.2.1"])
      s.add_dependency(%q<bundler>, ["~> 1.7"])
      s.add_dependency(%q<rake>, ["~> 10.3"])
    end
  else
    s.add_dependency(%q<cocoapods>, ["~> 1.0"])
    s.add_dependency(%q<mustache>, ["~> 0.99"])
    s.add_dependency(%q<open4>, [">= 0"])
    s.add_dependency(%q<redcarpet>, ["~> 3.2"])
    s.add_dependency(%q<rouge>, ["~> 1.5"])
    s.add_dependency(%q<sass>, ["~> 3.4"])
    s.add_dependency(%q<sqlite3>, ["~> 1.3"])
    s.add_dependency(%q<xcinvoke>, ["~> 0.2.1"])
    s.add_dependency(%q<bundler>, ["~> 1.7"])
    s.add_dependency(%q<rake>, ["~> 10.3"])
  end
end

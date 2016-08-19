# -*- encoding: utf-8 -*-
# stub: xcov 0.11 ruby lib

Gem::Specification.new do |s|
  s.name = "xcov"
  s.version = "0.11"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Carlos Vidal"]
  s.date = "2016-07-30"
  s.description = "xcov is a friendly visualizer for Xcode's code coverage files"
  s.email = ["nakioparkour@gmail.com"]
  s.executables = ["xcov"]
  s.files = ["bin/xcov"]
  s.homepage = "https://github.com/nakiostudio/xcov"
  s.licenses = ["MIT"]
  s.required_ruby_version = Gem::Requirement.new(">= 2.0.0")
  s.rubygems_version = "2.4.5.1"
  s.summary = "xcov is a friendly visualizer for Xcode's code coverage files"

  s.installed_by_version = "2.4.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<fastlane_core>, ["< 1.0.0", ">= 0.44.0"])
      s.add_runtime_dependency(%q<slack-notifier>, ["~> 1.3"])
      s.add_runtime_dependency(%q<terminal-table>, [">= 0"])
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<fastlane>, [">= 1.90.0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rubocop>, ["~> 0.35.1"])
      s.add_development_dependency(%q<rspec>, ["~> 3.1.0"])
      s.add_development_dependency(%q<pry>, [">= 0"])
      s.add_development_dependency(%q<yard>, ["~> 0.8.7.4"])
      s.add_development_dependency(%q<webmock>, ["~> 1.19.0"])
      s.add_development_dependency(%q<coveralls>, [">= 0"])
    else
      s.add_dependency(%q<fastlane_core>, ["< 1.0.0", ">= 0.44.0"])
      s.add_dependency(%q<slack-notifier>, ["~> 1.3"])
      s.add_dependency(%q<terminal-table>, [">= 0"])
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<fastlane>, [">= 1.90.0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rubocop>, ["~> 0.35.1"])
      s.add_dependency(%q<rspec>, ["~> 3.1.0"])
      s.add_dependency(%q<pry>, [">= 0"])
      s.add_dependency(%q<yard>, ["~> 0.8.7.4"])
      s.add_dependency(%q<webmock>, ["~> 1.19.0"])
      s.add_dependency(%q<coveralls>, [">= 0"])
    end
  else
    s.add_dependency(%q<fastlane_core>, ["< 1.0.0", ">= 0.44.0"])
    s.add_dependency(%q<slack-notifier>, ["~> 1.3"])
    s.add_dependency(%q<terminal-table>, [">= 0"])
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<fastlane>, [">= 1.90.0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rubocop>, ["~> 0.35.1"])
    s.add_dependency(%q<rspec>, ["~> 3.1.0"])
    s.add_dependency(%q<pry>, [">= 0"])
    s.add_dependency(%q<yard>, ["~> 0.8.7.4"])
    s.add_dependency(%q<webmock>, ["~> 1.19.0"])
    s.add_dependency(%q<coveralls>, [">= 0"])
  end
end

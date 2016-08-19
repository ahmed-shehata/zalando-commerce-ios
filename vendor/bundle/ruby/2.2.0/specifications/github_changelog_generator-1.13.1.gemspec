# -*- encoding: utf-8 -*-
# stub: github_changelog_generator 1.13.1 ruby lib

Gem::Specification.new do |s|
  s.name = "github_changelog_generator"
  s.version = "1.13.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Petr Korolev", "Olle Jonsson"]
  s.date = "2016-07-22"
  s.description = "Changelog generation has never been so easy. Fully automate changelog generation - this gem generate change log file based on tags, issues and merged pull requests from Github issue tracker."
  s.email = "sky4winder+github_changelog_generator@gmail.com"
  s.executables = ["git-generate-changelog", "github_changelog_generator"]
  s.files = ["bin/git-generate-changelog", "bin/github_changelog_generator"]
  s.homepage = "https://github.com/skywinder/Github-Changelog-Generator"
  s.licenses = ["MIT"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3")
  s.rubygems_version = "2.4.5.1"
  s.summary = "Script, that automatically generate changelog from your tags, issues, labels and pull requests."

  s.installed_by_version = "2.4.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rake>, [">= 10.0"])
      s.add_runtime_dependency(%q<github_api>, ["~> 0.12"])
      s.add_runtime_dependency(%q<colorize>, ["~> 0.7"])
      s.add_development_dependency(%q<overcommit>, [">= 0.31"])
      s.add_development_dependency(%q<rspec>, [">= 3.2"])
      s.add_development_dependency(%q<bundler>, [">= 1.7"])
      s.add_development_dependency(%q<rubocop>, [">= 0.31"])
    else
      s.add_dependency(%q<rake>, [">= 10.0"])
      s.add_dependency(%q<github_api>, ["~> 0.12"])
      s.add_dependency(%q<colorize>, ["~> 0.7"])
      s.add_dependency(%q<overcommit>, [">= 0.31"])
      s.add_dependency(%q<rspec>, [">= 3.2"])
      s.add_dependency(%q<bundler>, [">= 1.7"])
      s.add_dependency(%q<rubocop>, [">= 0.31"])
    end
  else
    s.add_dependency(%q<rake>, [">= 10.0"])
    s.add_dependency(%q<github_api>, ["~> 0.12"])
    s.add_dependency(%q<colorize>, ["~> 0.7"])
    s.add_dependency(%q<overcommit>, [">= 0.31"])
    s.add_dependency(%q<rspec>, [">= 3.2"])
    s.add_dependency(%q<bundler>, [">= 1.7"])
    s.add_dependency(%q<rubocop>, [">= 0.31"])
  end
end

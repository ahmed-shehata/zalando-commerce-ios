# -*- encoding: utf-8 -*-
# stub: reek 4.2.3 ruby lib

Gem::Specification.new do |s|
  s.name = "reek"
  s.version = "4.2.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Kevin Rutherford", "Timo Roessner", "Matijs van Zuijlen", "Piotr Szotkowski"]
  s.date = "2016-08-05"
  s.description = "Reek is a tool that examines Ruby classes, modules and methods and reports any code smells it finds."
  s.email = ["timo.roessner@googlemail.com"]
  s.executables = ["code_climate_reek", "reek"]
  s.extra_rdoc_files = ["CHANGELOG.md", "License.txt"]
  s.files = ["CHANGELOG.md", "License.txt", "bin/code_climate_reek", "bin/reek"]
  s.homepage = "https://github.com/troessner/reek/wiki"
  s.licenses = ["MIT"]
  s.rdoc_options = ["--main", "README.md", "-x", "assets/|bin/|config/|features/|spec/|tasks/"]
  s.required_ruby_version = Gem::Requirement.new(">= 2.1.0")
  s.rubygems_version = "2.4.5.1"
  s.summary = "Code smell detector for Ruby"

  s.installed_by_version = "2.4.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<codeclimate-engine-rb>, ["~> 0.3.1"])
      s.add_runtime_dependency(%q<parser>, [">= 2.3.1.2", "~> 2.3.1"])
      s.add_runtime_dependency(%q<rainbow>, ["~> 2.0"])
    else
      s.add_dependency(%q<codeclimate-engine-rb>, ["~> 0.3.1"])
      s.add_dependency(%q<parser>, [">= 2.3.1.2", "~> 2.3.1"])
      s.add_dependency(%q<rainbow>, ["~> 2.0"])
    end
  else
    s.add_dependency(%q<codeclimate-engine-rb>, ["~> 0.3.1"])
    s.add_dependency(%q<parser>, [">= 2.3.1.2", "~> 2.3.1"])
    s.add_dependency(%q<rainbow>, ["~> 2.0"])
  end
end

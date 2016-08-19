# -*- encoding: utf-8 -*-
# stub: ghi 1.2.0 ruby lib

Gem::Specification.new do |s|
  s.name = "ghi"
  s.version = "1.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Stephen Celis"]
  s.date = "2016-04-20"
  s.description = "GitHub Issues on the command line. Use your `$EDITOR`, not your browser.\n"
  s.email = "stephen@stephencelis.com"
  s.executables = ["ghi"]
  s.files = ["bin/ghi"]
  s.homepage = "https://github.com/stephencelis/ghi"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.5.1"
  s.summary = "GitHub Issues command line interface"

  s.installed_by_version = "2.4.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<pygments.rb>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<ronn>, [">= 0"])
    else
      s.add_dependency(%q<pygments.rb>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<ronn>, [">= 0"])
    end
  else
    s.add_dependency(%q<pygments.rb>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<ronn>, [">= 0"])
  end
end

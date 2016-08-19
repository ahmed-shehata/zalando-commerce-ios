# -*- encoding: utf-8 -*-
# stub: travis 1.8.2 ruby lib

Gem::Specification.new do |s|
  s.name = "travis"
  s.version = "1.8.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Konstantin Haase", "Hiro Asari", "Henrik Hodne", "joshua-anderson", "Aaron Hill", "Peter Souter", "Christopher Grim", "Peter van Dijk", "Max Barnash", "Carlos Palhares", "Dan Buch", "Mathias Meyer", "Corinna Wiesner", "Stefan Nordhausen", "Thais Camilo and Konstantin Haase", "Andreas Tiefenthaler", "David Rodr\u{ed}guez", "Jon-Erik Schneiderhan", "Jonne Ha\u{df}", "Josh Kalderimis", "Julia S.Simon", "Justin Lambert", "Benjamin Manns", "Laurent Petit", "Maarten van Vliet", "Mario Visic", "Adam Lavin", "Matthias Bussonnier", "Basarat Ali Syed", "Eric Herot", "Miro Hron\u{10d}ok", "Neamar", "Nicolas Bessi (nbessi)", "Peter Bengtsson", "Adrien Brault", "Piotr Sarnacki", "Rapha\u{eb}l Pinson", "Rob Hoelz", "Robert Van Voorhees", "Tobias Wilken", "Zachary Gershman", "Zachary Scott", "jeffdh", "john muhl", "Michael Mior", "George Millo", "Daniel Chatfield", "Jacob Burkhart", "Joe Rafaniello"]
  s.date = "2016-01-12"
  s.description = "CLI and Ruby client library for Travis CI"
  s.email = ["konstantin.mailinglists@googlemail.com", "asari.ruby@gmail.com", "me@henrikhodne.com", "j@zatigo.com", "aa1ronham@gmail.com", "p.morsou@gmail.com", "chrisg@luminal.io", "peter.van.dijk@netherlabs.nl", "i.am@anhero.ru", "me@xjunior.me", "dan@meatballhat.com", "meyer@paperplanes.de", "wiesner@avarteq.de", "stefan.nordhausen@immobilienscout24.de", "dev+narwen+rkh@rkh.im", "at@an-ti.eu", "deivid.rodriguez@gmail.com", "jon-erik.schneiderhan@meyouhealth.com", "me@jhass.eu", "josh.kalderimis@gmail.com", "julia.simon@biicode.com", "jlambert@eml.cc", "benmanns@gmail.com", "laurent.petit@gmail.com", "maartenvanvliet@gmail.com", "mario@mariovisic.com", "adam@lavoaster.co.uk", "bussonniermatthias@gmail.com", "basaratali@gmail.com", "eric.github@herot.com", "miro@hroncok.cz", "neamar@neamar.fr", "nbessi@users.noreply.github.com", "peterbe@mozilla.com", "adrien.brault@gmail.com", "drogus@gmail.com", "raphael.pinson@camptocamp.com", "rob@hoelz.ro", "rcvanvo@gmail.com", "tw@cloudcontrol.de", "pair+zg@pivotallabs.com", "e@zzak.io", "jeffdh@gmail.com", "git@johnmuhl.com", "mmior@uwaterloo.ca", "georgejulianmillo@gmail.com", "chatfielddaniel@gmail.com", "jburkhart@engineyard.com", "jrafanie@users.noreply.github.com"]
  s.executables = ["travis"]
  s.files = ["bin/travis"]
  s.homepage = "https://github.com/travis-ci/travis.rb"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.5.1"
  s.summary = "Travis CI client"

  s.installed_by_version = "2.4.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<faraday>, ["~> 0.9"])
      s.add_runtime_dependency(%q<faraday_middleware>, [">= 0.9.1", "~> 0.9"])
      s.add_runtime_dependency(%q<highline>, ["~> 1.6"])
      s.add_runtime_dependency(%q<backports>, [">= 0"])
      s.add_runtime_dependency(%q<gh>, ["~> 0.13"])
      s.add_runtime_dependency(%q<launchy>, ["~> 2.1"])
      s.add_runtime_dependency(%q<typhoeus>, [">= 0.6.8", "~> 0.6"])
      s.add_runtime_dependency(%q<pusher-client>, ["~> 0.4"])
      s.add_development_dependency(%q<rspec>, ["~> 2.12"])
      s.add_development_dependency(%q<sinatra>, ["~> 1.3"])
      s.add_development_dependency(%q<rack-test>, ["~> 0.6"])
    else
      s.add_dependency(%q<faraday>, ["~> 0.9"])
      s.add_dependency(%q<faraday_middleware>, [">= 0.9.1", "~> 0.9"])
      s.add_dependency(%q<highline>, ["~> 1.6"])
      s.add_dependency(%q<backports>, [">= 0"])
      s.add_dependency(%q<gh>, ["~> 0.13"])
      s.add_dependency(%q<launchy>, ["~> 2.1"])
      s.add_dependency(%q<typhoeus>, [">= 0.6.8", "~> 0.6"])
      s.add_dependency(%q<pusher-client>, ["~> 0.4"])
      s.add_dependency(%q<rspec>, ["~> 2.12"])
      s.add_dependency(%q<sinatra>, ["~> 1.3"])
      s.add_dependency(%q<rack-test>, ["~> 0.6"])
    end
  else
    s.add_dependency(%q<faraday>, ["~> 0.9"])
    s.add_dependency(%q<faraday_middleware>, [">= 0.9.1", "~> 0.9"])
    s.add_dependency(%q<highline>, ["~> 1.6"])
    s.add_dependency(%q<backports>, [">= 0"])
    s.add_dependency(%q<gh>, ["~> 0.13"])
    s.add_dependency(%q<launchy>, ["~> 2.1"])
    s.add_dependency(%q<typhoeus>, [">= 0.6.8", "~> 0.6"])
    s.add_dependency(%q<pusher-client>, ["~> 0.4"])
    s.add_dependency(%q<rspec>, ["~> 2.12"])
    s.add_dependency(%q<sinatra>, ["~> 1.3"])
    s.add_dependency(%q<rack-test>, ["~> 0.6"])
  end
end

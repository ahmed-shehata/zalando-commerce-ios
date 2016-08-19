source 'https://rubygems.org'

ruby 2.2

group :calypso do
  gem 'thor'
  gem 'xcpretty'
  gem 'github_api'
  gem 'daemons'
  gem 'xcov'
  gem 'jazzy'
  gem 'github_changelog_generator'
  # activesupport is used by cocoapods, which is used by jazzy
  # newer activesupport is not compatible with ruby 2.0 used on on buddybuild / travis
  gem 'activesupport', '~> 4.0'
  # rack is used by oauth2, which is used by github_api
  # newer rack is not compatible with ruby 2.0 used on on buddybuild / travis
  gem 'rack', '~> 1.6'
end

group :tools do
  gem 'rubocop'
  gem 'travis'
  gem 'ghi'
  gem 'reek'
end

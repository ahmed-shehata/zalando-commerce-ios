source 'https://rubygems.org'

group :build do
  gem 'thor'
  gem 'xcpretty'
  gem 'github_api'
end

group :development do
  gem 'rubocop'
  gem 'travis'
  gem 'ghi'
  gem 'reek'
  gem 'daemons'
  gem 'xcov'
end

group :doc do
  gem 'jazzy'
  gem 'github_changelog_generator'
  # activesupport is used by cocoapods, which is used by jazzy
  # newer activesupport is not compatible with ruby 2.0 used on on buddybuild / travis
  gem 'activesupport', '~> 4.0'
end

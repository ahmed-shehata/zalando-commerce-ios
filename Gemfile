source 'https://rubygems.org'

def ruby_version
  path = File.expand_path('../.ruby-version', __FILE__)
  File.open(path).readlines.first
end

ruby ruby_version

group :calypso do
  gem 'awesome_print'
  gem 'cocoapods'
  gem 'git'
  gem 'github_api'
  gem 'httparty'
  gem 'jazzy'
  gem 'rubocop'
  gem 'thor'
  gem 'xcpretty'
end

group :development do
  gem 'travis'
end

group :jekyll_plugins do
  gem 'github-pages'
end

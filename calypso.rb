#!/usr/bin/env ruby
require 'date'
require 'thor'
require 'fileutils'
require 'pathname'
require 'optparse'

require_relative 'lib/calypso/clean'
require_relative 'lib/calypso/deps'
require_relative 'lib/calypso/lint'
require_relative 'lib/calypso/docs'
require_relative 'lib/calypso/ci'
require_relative 'lib/calypso/xcode'
require_relative 'lib/calypso/coverage'

require_relative 'lib/calypso/issues'
require_relative 'lib/calypso/release/release'
require_relative 'lib/calypso/release/version'
require_relative 'lib/calypso/release/pod'
require_relative 'lib/calypso/release/carthage'

$stdout.sync = $stderr.sync = true

module Calypso
  class CLI < Thor
    include Calypso

    desc 'clean', 'Clean source code'
    subcommand 'clean', Clean

    desc 'deps', 'Prepare depended libraries'
    subcommand 'deps', Deps

    desc 'lint', 'Check and format source code style'
    subcommand 'lint', Lint

    desc 'docs', 'Generate documentation'
    subcommand 'docs', Docs

    desc 'ci', 'BuddyBuild continuous integration'
    subcommand 'ci', BuddyBuildCI

    desc 'xcode', 'Building shortcuts'
    subcommand 'xcode', Xcode

    desc 'coverage', 'Code coverage'
    subcommand 'coverage', Coverage

    desc 'pod', 'CocoaPods commands'
    subcommand 'pod', Pod

    desc 'version', 'Updates source versions'
    subcommand 'version', Version

    desc 'release', 'Releases of new source versions'
    subcommand 'release', Release

    desc 'carthage', 'Prepares Carthage releases'
    subcommand 'carthage', Carthage

    desc 'issues', 'Github Issues reporter'
    subcommand 'issues', Issues
  end
end

Calypso::CLI.start

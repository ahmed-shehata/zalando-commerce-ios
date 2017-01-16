#!/usr/bin/env ruby
require 'date'
require 'thor'
require 'fileutils'
require 'pathname'
require 'optparse'

require_relative 'lib/calypso/clean'
require_relative 'lib/calypso/deps'
require_relative 'lib/calypso/lint'
require_relative 'lib/calypso/simctl'
require_relative 'lib/calypso/xcodebuild'
require_relative 'lib/calypso/codecov'

require_relative 'lib/calypso/issues'
require_relative 'lib/calypso/release/release'
require_relative 'lib/calypso/release/version'
require_relative 'lib/calypso/release/pod'
require_relative 'lib/calypso/release/carthage'
require_relative 'lib/calypso/release/docs'

$stdout.sync = $stderr.sync = true

module Calypso

  class CLI < Thor
    include Calypso

    desc 'clean', 'Clean source code'
    subcommand 'clean', Clean

    desc 'docs', 'Generate docs'
    subcommand 'docs', Docs

    desc 'deps', 'Prepare depended libraries'
    subcommand 'deps', Deps

    desc 'lint', 'Check and format source code style'
    subcommand 'lint', Lint

    desc 'xcodebuild', 'Building shortcuts'
    subcommand 'xcodebuild', XcodeBuild

    desc 'simctl', 'Simulator setup'
    subcommand 'simctl', SimCtl

    desc 'codecov', 'Code coverage reports'
    subcommand 'codecov', Codecov

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

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
require_relative 'lib/calypso/pod'

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
  end
end

Calypso::CLI.start

require 'thor'
require 'fileutils'
require_relative 'utils/run'

module Calypso

  CART_DIR = 'Carthage'.freeze

  class Deps < Thor

    MAC_DEPS = %w(swifter Freddy).freeze

    desc 'build', 'Build dependencies'
    option :quick, type: :boolean, default: true,
                   desc: 'true: uses \'--cache-builds\', false: uses \'--no-use-binaries\''
    def build
      run_carthage 'bootstrap', options
      run_carthage 'build', options, deps: MAC_DEPS, platform: 'Mac'
    end

    desc 'update [-d dep1, dep2, ..., dep3]', 'Update dependencies'
    option :quick, type: :boolean, default: true,
                   desc: 'true: uses \'--cache-builds\', false: uses \'--no-use-binaries\''
    option :dependencies, type: :array, aliases: 'd',
                          desc: 'list of dependencies to build'
    def update
      run_carthage 'update', options, deps: options[:dependencies]
      update_mac_deps options
      run 'open Carthage/Build/iOS'
    end

    desc 'rebuild', 'Clean and build dependencies'
    def rebuild
      invoke :clean
      invoke :build
    end

    desc 'clean', 'Clean dependencies'
    def clean
      FileUtils.rm_rf CART_DIR
    end

    include Run

    private

    def update_mac_deps(options)
      deps = options[:dependencies]
      if deps.nil?
        run_carthage 'update', options, deps: MAC_DEPS, platform: 'Mac'
      elsif !(deps & MAC_DEPS).empty?
        run_carthage 'update', options, deps: deps, platform: 'Mac'
      end
    end

    def run_carthage(command, options, deps: nil, platform: 'iOS')
      all_args = ['--platform', platform]
      all_args << (options[:quick] ? '--cache-builds' : '--no-use-binaries')
      all_args += deps unless deps.nil?
      run "carthage #{command} #{all_args.join ' '}"
    end

  end

end

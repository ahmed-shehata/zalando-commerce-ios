require 'thor'
require 'fileutils'
require_relative 'utils/run'

module Calypso

  CART_DIR = 'Carthage'.freeze
  CART_RES = 'Cartfile.resolved'.freeze

  class Deps < Thor

    MAC_DEPS = %w(swifter Freddy).freeze

    desc 'build', 'Build dependencies'
    def build
      run 'carthage bootstrap --platform iOS --no-use-binaries'
      run "carthage build --platform Mac #{MAC_DEPS.join ' '}"
    end

    desc 'update [dep1, dep2, ..., dep3]', 'Update dependencies'
    def update(*args)
      run "carthage update --platform iOS --no-use-binaries #{args.join ' '}"
      if args.empty?
        run "carthage update --platform Mac --no-use-binaries #{MAC_DEPS.join ' '}"
      elsif !(args & MAC_DEPS).empty?
        run "carthage update --platform Mac --no-use-binaries #{args.join ' '}"
      end
      run 'open Carthage/Build/iOS'
    end

    desc 'clean', 'Clean dependencies'
    def clean
      FileUtils.rm_rf CART_DIR
      FileUtils.rm_rf CART_RES
    end

    desc 'rebuild', 'Clean and build dependencies'
    def rebuild
      invoke :clean
      invoke :build
    end

    include Run

  end

end

require 'thor'
require 'fileutils'
require_relative 'run'

module Calypso

  CART_DIR = 'Carthage'.freeze
  CART_RES = 'Cartfile.resolved'.freeze

  class Deps < Thor

    MAC_DEPS = 'swifter SwiftyJSON'.freeze

    desc 'build', 'Build dependencies'
    def build
      run 'carthage bootstrap --platform iOS --no-use-binaries'
      run "carthage build --platform Mac #{MAC_DEPS}"
    end

    desc 'update', 'Update dependencies'
    def update
      run "carthage update --platform iOS --no-use-binaries #{MAC_DEPS}"
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

    desc 'uncached', 'Builds only if they\'re not cached (used in CI)'
    def uncached
      if cached?
        log "#{CART_RES} unchanged. Assuming correctly cached #{CART_DIR}"
        return
      end
      invoke :build
      FileUtils.cp CART_RES, CART_DIR
    end

    include Run

    private

    def cached?
      system("diff -q #{CART_RES} #{CART_DIR}/#{CART_RES} 2> /dev/null")
    end

  end

end

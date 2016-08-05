require 'thor'
require 'fileutils'
require_relative 'run'

module Calypso

  CART_DIR = 'Carthage'.freeze
  CART_RES = 'Cartfile.resolved'.freeze

  class Deps < Thor

    desc 'build', 'Build dependencies'
    def build
      run 'carthage bootstrap --platform iOS'
    end

    desc 'update', 'Update dependencies'
    def update
      run 'carthage update --platform iOS'
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
        puts "#{CART_RES} unchanged. Assuming correctly cached #{CART_DIR}"
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

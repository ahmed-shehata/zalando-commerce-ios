require 'thor'
require 'fileutils'

module Calypso

  class Deps < Thor

    desc 'build', 'Build dependencies'
    def build
      system 'carthage update --platform iOS'
    end

    desc 'clean', 'Clean dependencies'
    def clean
      FileUtils.rm_rf 'Carthage'
    end

    desc 'rebuild', 'Clean and build dependencies'
    def rebuild
      clean
      build
    end

  end

end

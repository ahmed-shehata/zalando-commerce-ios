require 'thor'
require 'fileutils'
require_relative '../utils/run'

module Calypso

  class Carthage < Thor

    desc 'build', 'Builds and creates an archive'
    def build
      FileUtils.rm_rf Dir['ZalandoCommerce{API,UI}.framework.zip']
      run 'carthage build --no-skip-current --platform iOS'
      run 'carthage archive ZalandoCommerceAPI ZalandoCommerceUI'
    end

    include Run

  end

end

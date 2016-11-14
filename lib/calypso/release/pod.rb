require 'thor'
require_relative '../run'

module Calypso

  class Pod < Thor

    option :local, type: :boolean
    option :silent, type: :boolean
    desc 'validate', 'Validates and builds pod'
    def validate
      if options[:local]
        run_pod 'lib lint', options[:silent]
      else
        run_pod 'spec lint', options[:silent]
      end
    end

    option :silent, type: :boolean
    desc 'publish', 'Publish new version to CocoaPods'
    def publish
      run_pod 'trunk push', options[:silent]
    end

    private

    include Run

    def run_pod(subcommand, silent)
      run "pod #{subcommand} AtlasSDK.podspec --allow-warnings #{silent ? '--silent' : ''}"
    end

  end

end

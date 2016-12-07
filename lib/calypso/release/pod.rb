require 'thor'
require_relative '../run'

module Calypso

  class Pod < Thor

    option :local, type: :boolean
    option :silent, type: :boolean
    option :verbose, type: :boolean
    option :clean, type: :boolean, default: true
    desc 'validate', 'Validates and builds pod'
    def validate
      if options[:local]
        run_pod 'lib lint', options
      else
        run_pod 'spec lint', options
      end
    end

    option :silent, type: :boolean
    desc 'publish', 'Publish new version to CocoaPods'
    def publish
      run_pod 'trunk push', options
    end

    private

    include Run

    def run_pod(subcommand, options)
      args = ['--allow-warnings']
      if options[:silent]
        args << '--silent'
      elsif options[:verbose]
        args << '--verbose'
      end
      args << (options[:clean] ? '' : '--no-clean')

      run "pod #{subcommand} AtlasSDK.podspec #{args.join ' '}"
    end

  end

end

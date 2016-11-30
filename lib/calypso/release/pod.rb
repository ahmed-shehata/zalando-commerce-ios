require 'thor'
require_relative '../run'

module Calypso

  class Pod < Thor

    option :local, type: :boolean
    option :silent, type: :boolean
    option :verbose, type: :boolean
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
      verbosity_arg = if options[:silent]
                        '--silent'
                      elsif options[:verbose]
                        '--verbose'
                      end

      run "pod #{subcommand} AtlasSDK.podspec --allow-warnings #{verbosity_arg}"
    end

  end

end

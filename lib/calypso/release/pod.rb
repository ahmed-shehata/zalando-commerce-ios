require 'thor'
require_relative '../utils/run'

module Calypso

  class Pod < Thor

    PODSPECS = ['AtlasSDK.podspec', 'AtlasUI.podspec'].freeze

    option :local, type: :boolean
    option :silent, type: :boolean
    option :verbose, type: :boolean
    option :quick, type: :boolean, default: false
    desc 'validate', 'Validates and builds pod'
    def validate
      subcommand = if options[:local]
                     'lib'
                   else
                     'spec'
                   end
      args = build_args(options, ['--fail-fast'])
      args += '--quick' if options[:quick]
      run_pod "#{subcommand} lint #{PODSPECS.join ' '}", args
    end

    option :silent, type: :boolean
    option :verbose, type: :boolean
    desc 'publish', 'Publish new version to CocoaPods'
    def publish
      PODSPECS.each do |ps|
        run_pod "trunk push #{ps}", build_args(options)
      end
    end

    private

    include Run

    def build_args(options, default_args = [])
      args = default_args
      args += ['--allow-warnings']
      if options[:silent]
        args << '--silent'
      elsif options[:verbose]
        args << '--verbose'
      end
      args
    end

    def run_pod(subcommand, args)
      run "pod #{subcommand} #{args.join ' '}"
    end

  end

end

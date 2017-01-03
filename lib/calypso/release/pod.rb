require 'thor'
require_relative '../run'

module Calypso

  class Pod < Thor

    PODSPECS = ['AtlasSDK.podspec', 'AtlasUI.podspec'].freeze

    option :local, type: :boolean
    option :silent, type: :boolean
    option :verbose, type: :boolean
    desc 'validate', 'Validates and builds pod'
    def validate
      subcommand = if options[:local]
                     'lib'
                   else
                     'spec'
                   end
      run_pod "#{subcommand} lint #{PODSPECS.join ' '}", options
    end

    option :silent, type: :boolean
    option :verbose, type: :boolean
    desc 'publish', 'Publish new version to CocoaPods'
    def publish
      PODSPECS.each do |ps|
        run_pod "trunk push #{ps}", options
      end
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

      run "pod #{subcommand} #{args.join ' '}"
    end

  end

end

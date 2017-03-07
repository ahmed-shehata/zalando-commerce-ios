require 'thor'
require_relative '../utils/run'

module Calypso

  class Pod < Thor

    PODSPECS = ['ZalandoCommerceAPI.podspec', 'ZalandoCommerceUI.podspec'].freeze

    desc 'validate', 'Validates and builds pod'
    option :local, type: :boolean, default: false,
                   desc: 'true - runs "pod lib ..."; false - runs "pod spec ..."'
    option :silent, type: :boolean, default: false,
                    desc: 'Adds --silent to "pod" command, takes precedence over --verbose'
    option :verbose, type: :boolean, default: false,
                     desc: 'Adds --verbose to "pod" command, gives precedence to --silent'
    option :quick, type: :boolean, default: false,
                   desc: 'Adds --quick to "pod" command'
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

    desc 'publish', 'Publish new version to CocoaPods'
    option :silent, type: :boolean,
                    desc: 'Adds --silent to "pod" command, takes precedence over --verbose'
    option :verbose, type: :boolean,
                     desc: 'Adds --verbose to "pod" command, gives precedence to --silent'
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

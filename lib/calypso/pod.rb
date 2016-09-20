require 'thor'
require_relative 'run'

VERSION_FILE = './lib/version.rb'.freeze

module Calypso

  class Pod < Thor

    desc 'lint_spec', 'Lint Podspec'
    def lint_spec
      run 'pod spec lint AtlasSDK.podspec --allow-warnings'
    end

    desc 'lint_lib', 'Lint Library'
    def lint_lib
      run 'pod lib lint AtlasSDK.podspec --allow-warnings'
    end

    desc 'release', 'Release new version: create new tag and push to the GitHub'
    def release
      current_version = read_current_version
      say "Please, add new AtlasSDK version (current #{current_version}):", :blue
      new_version = ask 'Please, enter new version', :blue
      write_new_version(new_version)

      invoke :lint_lib

      say 'Changing project version', :blue
      run "/usr/libexec/PlistBuddy -c 'Set :CFBundleShortVersionString #{new_version}' AtlasSDK/AtlasSDK/Info.plist"
      run "/usr/libexec/PlistBuddy -c 'Set :CFBundleShortVersionString #{new_version}' AtlasUI/AtlasUI/Info.plist"

      say 'Check and execute the following commands:', :blue
      say "git add -A && git commit -m 'Release #{new_version}.' \n"\
          "git tag '#{new_version}' \n"\
          'git push --tags', :yellow
    end

    desc 'deploy', 'Deploy new version to CocoaPods'
    def deploy
      invoke :lint_spec
      run 'pod repo push AtlasSDK.podspec'
    end

    private

    include Run

    def read_current_version
      file_str = ''
      if File.exist?(VERSION_FILE)
        file_str = File.open(VERSION_FILE, 'r', &:read)
      end

      file_str.match(/[0-9\.]+/)[0]
    end

    def write_new_version(new_version)
      File.open(VERSION_FILE, 'w') { |file| file.write("VERSION='#{new_version}'") }
    end

  end

end

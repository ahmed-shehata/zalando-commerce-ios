require 'thor'
require_relative 'run'

FILE_NAME = 'version.rb'

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
      say "Pleae, add new AtlasSDK version (current #{current_version}):", :blue
      new_version = ask 'Please, enter new version', :blue
      write_new_version(new_version)

      invoke :lint_lib
    end

    desc 'deploy', 'Deploy new version to CocoaPods'
    def deploy
      invoke :lint
    end

    private

    include Run

    def read_current_version
      file_str = ''
      if File.exists?(FILE_NAME)
          file_str = File.open(FILE_NAME, 'r') {|file| file.read }
      end

      return file_str.match(/[0-9\.]+/)[0]
    end

    def write_new_version(new_version)
      file_str = ''
      if File.exists?(FILE_NAME)
        File.open(FILE_NAME, 'w') {|file| file.write("VERSION='#{new_version}'") }
      end
    end

  end

end

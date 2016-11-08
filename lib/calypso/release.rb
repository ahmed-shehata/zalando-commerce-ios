require 'thor'
require_relative 'run'

VERSION_FILE = File.expand_path('../../version.rb', __FILE__)
require VERSION_FILE

module Calypso

  class Release < Thor

    desc 'create_version', 'Creates new version: updates plist files, add a tag and push to the GitHub'
    def create_version
      new_version = ask("Enter new version (current #{ATLAS_VERSION}):", :blue)
      new_version = ATLAS_VERSION if new_version.empty?
      write_new_version(new_version)

      update_plist_version(new_version: new_version, plist: 'AtlasSDK/AtlasSDK/Info.plist')
      update_plist_version(new_version: new_version, plist: 'AtlasUI/AtlasUI/Info.plist')

      say 'Execute the following commands:'
      say "  git add -A && git commit -m 'Release #{new_version}'\n"\
        "  git tag '#{new_version}'\n"\
        '  git push --tags', :yellow
    end

    private

    include Run

    def write_new_version(new_version)
      File.open(VERSION_FILE, 'w') { |file| file.puts("ATLAS_VERSION = '#{new_version}'") }
    end

    def update_plist_version(new_version:, plist:)
      run "/usr/libexec/PlistBuddy -c 'Set :CFBundleShortVersionString #{new_version}' '#{plist}'"
    end

  end

end

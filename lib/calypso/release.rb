require 'thor'
require 'git'
require_relative 'run'

VERSION_FILE = File.expand_path('../../version.rb', __FILE__)
require VERSION_FILE

module Calypso

  class Release < Thor

    desc 'create_version', 'Creates new version: updates plist files, add a tag and push to the GitHub'
    def create_version
      abort('Please commit all changes before creating new version') if repo_changes?

      new_version = ask("Enter new version (current #{ATLAS_VERSION}):", :blue)
      new_version = ATLAS_VERSION if new_version.empty?
      write_new_version(new_version)

      update_plist_version(new_version, 'AtlasSDK/AtlasSDK/Info.plist', 'AtlasUI/AtlasUI/Info.plist')

      say 'Execute the following commands:'
      say "  git tag '#{new_version}'\n"\
        '  git push --tags', :yellow
    end

    private

    include Run

    def repo
      @repo ||= Git.open(File.expand_path('../../..', __FILE__))
    end

    def write_new_version(new_version)
      File.open(VERSION_FILE, 'w') { |file| file.puts("ATLAS_VERSION = '#{new_version}'") }
    end

    def update_plist_version(new_version, *args)
      args.each do |plist|
        run "/usr/libexec/PlistBuddy -c 'Set :CFBundleShortVersionString #{new_version}' '#{plist}'"
        repo.add plist
      end
      repo.commit "[auto] Updated plist version to #{new_version} h"
    end

    def repo_changes?
      changed = repo.status.map(&:type).compact
      changed.count.nonzero?
    end

  end

end

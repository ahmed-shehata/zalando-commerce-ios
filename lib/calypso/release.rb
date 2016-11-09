require 'thor'
require 'git'
require_relative 'run'

VERSION_FILE = File.expand_path('../../version.rb', __FILE__)
require VERSION_FILE

module Calypso

  class Release < Thor

    option :tag, type: :boolean
    option :push, type: :boolean
    desc 'create_version', 'Creates new version: updates plist files, add a tag and push to the GitHub'
    def create_version
      if repo_changes?
        say 'Please commit all changes before creating new version', :red
        abort
      end

      new_version = ask("Enter new version (current #{ATLAS_VERSION}):", :blue)
      new_version = ATLAS_VERSION if new_version.empty?

      update_plist(new_version, 'AtlasSDK/AtlasSDK/Info.plist')
      update_plist(new_version, 'AtlasUI/AtlasUI/Info.plist')
      update_version_file(new_version)
      commit_version(new_version)

      if options[:tag] || yes?("Would you like to tag current commit with #{new_version}?", :red)
        say "  git tag '#{new_version}'", :yellow
      end
      if options[:push] || yes?('Would you like to push changes?', :red)
        say '  git push --tags', :yellow
      end
    end

    private

    include Run

    def repo
      @repo ||= Git.open(File.expand_path('../../..', __FILE__))
    end

    def update_version_file(new_version)
      File.open(VERSION_FILE, 'w') { |file| file.puts("ATLAS_VERSION = '#{new_version}'") }
      repo.add VERSION_FILE
    end

    def update_plist(new_version, plist)
      run "/usr/libexec/PlistBuddy -c 'Set :CFBundleShortVersionString #{new_version}' '#{plist}'"
      repo.add plist
    end

    def commit_version(new_version)
      repo.commit "[auto] Updated version to #{new_version}"
    end

    def repo_changes?
      changed = repo.status.map(&:type).compact
      changed.count.nonzero?
    end

  end

end

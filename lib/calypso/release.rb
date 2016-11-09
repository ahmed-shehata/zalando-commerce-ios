require 'thor'
require 'git'
require_relative 'run'

VERSION_FILE = File.expand_path('../../version.rb', __FILE__)
require VERSION_FILE

module Calypso

  class Release < Thor

    option :tag, type: :boolean, default: true
    option :push, type: :boolean, default: true
    desc 'create_version', 'Creates new version: updates plist files, add a tag and push to the GitHub'
    def create_version(version = nil)
      if repo_changes?
        say 'Please commit all changes before creating new version', :red
        abort
      end

      new_version = ask_new_version(version)

      update_plist(new_version, 'AtlasSDK/AtlasSDK/Info.plist')
      update_plist(new_version, 'AtlasUI/AtlasUI/Info.plist')
      update_version_file(new_version)
      commit_version(new_version)

      tag_new_version(options, new_version)
      push_new_version(options)
    end

    private

    include Run

    def repo
      @repo ||= Git.open(File.expand_path('../../..', __FILE__))
    end

    def ask_new_version(version = nil)
      new_version = version || ask("Enter new version (current #{ATLAS_VERSION}):", :blue)
      new_version = ATLAS_VERSION if new_version.empty?

      if new_version == ATLAS_VERSION
        say "No change in version (#{ATLAS_VERSION}), quitting", :green
        abort
      end

      new_version
    end

    def tag_new_version(options, new_version)
      dry_run "git tag #{new_version}", real_run: options[:tag]
    end

    def push_new_version(options)
      dry_run 'git push --tags', real_run: options[:push]
    end

    def dry_run(cmd, real_run: true)
      if real_run
        run cmd
      else
        say "Don't forget to run:\n  #{cmd}", :yellow
      end
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
    rescue StandardError => e
      say e, :red
    end

    def repo_changes?
      changed = repo.status.map(&:type).compact
      changed.count.nonzero?
    end

  end

end

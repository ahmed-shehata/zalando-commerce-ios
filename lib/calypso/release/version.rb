require 'thor'
require 'git'
require_relative '../run'

VERSION_FILE = File.expand_path('../../../version.rb', __FILE__)
require VERSION_FILE

module Calypso

  class Version < Thor

    option :tag, type: :boolean, default: true
    option :push, type: :boolean, default: true
    desc 'create', 'Creates new version: updates plist files, add a tag and push to the GitHub'
    def create(version = nil)
      log_abort 'Please create version only from master branch' unless master_branch?
      log_abort 'Please commit all changes before creating new version' if repo_contains_changes?

      new_version = ask_new_version(version)

      update_plist(new_version, 'AtlasSDK/AtlasSDK/Info.plist')
      update_plist(new_version, 'AtlasUI/AtlasUI/Info.plist')
      update_version_file(new_version)
      commit_version(new_version)

      tag_new_version(options, new_version)
      push_new_version(options)

      new_version
    end

    private

    include Run

    def repo
      @repo ||= Git.open(File.expand_path('../../../..', __FILE__))
    end

    def master_branch?
      current_branch == 'master'
    end

    def current_branch
      `git rev-parse --abbrev-ref HEAD`
    end

    def ask_new_version(version = nil)
      new_version = version || ask("Enter new version (current #{ATLAS_VERSION}):", :blue)
      new_version = ATLAS_VERSION if new_version.empty?

      log_abort "No change in version (#{ATLAS_VERSION}), quitting" if new_version == ATLAS_VERSION

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
        log "Don't forget to run:\n  #{cmd}"
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
      log_abort e
    end

    def repo_contains_changes?
      changed = repo.status.map(&:type).compact
      changed.count.nonzero?
    end

  end

end

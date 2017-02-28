require 'thor'

require_relative '../utils/run'
require_relative '../utils/git_cmd'
require_relative '../consts'

VERSION_FILE = File.expand_path('../../../version.rb', __FILE__)
require VERSION_FILE

module Calypso

  class Version < Thor

    option :tag, type: :boolean, default: true,
                 desc: 'Create git tag after commiting version changes'
    option :push, type: :boolean, default: true,
                  desc: 'Push tags and local commits'
    option :master, type: :boolean, default: false,
                    desc: 'Don\'t quit on non-master branch'
    option :dirty, type: :boolean, default: false,
                   desc: 'Don\'t quit on uncommited changes'
    option :force, type: :boolean, default: false,
                   desc: 'Don\'t quit on no version change'
    desc 'create', 'Creates new version: updates plist files, add a tag and push to the GitHub'
    def create(version = nil)
      log_abort 'Please create version only from master branch' unless !options[:master] || master_branch?
      log_abort 'Please commit all changes before creating new version' if !options[:dirty] && repo_contains_changes?

      new_version = ask_new_version(options, version)

      update_versions(new_version)
      git_new_version(new_version, options)

      new_version
    end

    private

    include Run
    include GitCmd

    def ask_new_version(options, version = nil)
      new_version = version || ask("Enter new version (current #{ATLAS_VERSION}):", :blue)
      new_version = ATLAS_VERSION if new_version.empty?

      log_abort "No change in version (#{ATLAS_VERSION}), quitting" \
        if new_version == ATLAS_VERSION && !options[:force]

      new_version
    end

    def update_versions(new_version)
      update_projects(new_version)
      update_version_file(new_version)
    end

    def update_projects(version)
      VERSIONABLE_PROJECTS.each do |project|
        full_path = File.expand_path("../../../../#{project}", __FILE__)
        update_project(full_path, version)
      end
    end

    def update_project(path, version)
      run_agvtool path, version
      Dir["#{path}/#{VERSIONED_PROJECT_FILES}"].each do |file|
        repo.add file
      end
    end

    def run_agvtool(path, version)
      run "cd '#{path}' && xcrun agvtool new-marketing-version #{version}"
      run "cd '#{path}' && xcrun agvtool new-version -all #{version}"
    end

    def git_new_version(new_version, options)
      commit_version(new_version)
      tag_new_version(options, new_version)
      push_new_version(options)
    end

    def tag_new_version(options, new_version)
      dry_run "git tag #{new_version}", real_run: options[:tag]
    end

    def push_new_version(options)
      dry_run 'git push', real_run: options[:push]
      dry_run 'git push --tags', real_run: options[:push]
    end

    def update_version_file(new_version)
      File.open(VERSION_FILE, 'w') { |file| file.puts("ATLAS_VERSION = '#{new_version}'") }
      repo.add VERSION_FILE
    end

    def commit_version(new_version)
      repo.commit "[auto] Updated version to #{new_version}"
    rescue Git::GitExecuteError => e
      error_lines = e.to_s.split("\n")
      details = error_lines[0..-2]
      last_message = error_lines.last
      log_warn details
      log_abort last_message
    end

    def dry_run(cmd, real_run: true)
      if real_run
        run cmd
      else
        log "Don't forget to run:\n  #{cmd}"
      end
    end

    def repo_contains_changes?
      changed = repo.status.map(&:type).compact
      changed.count.nonzero?
    end

  end

end

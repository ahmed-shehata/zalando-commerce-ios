require 'thor'
require 'git'
require 'awesome_print'
require_relative '../issues'
require_relative 'version'
require_relative '../utils/run'
require_relative '../lint'
require_relative '../github_client/github_client'

module Calypso

  class Release < Thor

    desc 'create', 'Create new release'
    option :tag, type: :boolean, default: true,
                 desc: 'Passed to "version create" command'
    option :push, type: :boolean, default: true,
                  desc: 'Passed to "version create" command'
    option :master, type: :boolean, default: false,
                    desc: 'Passed to "version create" command'
    option :force, type: :boolean, default: false,
                   desc: 'Passed to "version create" command'
    option :dirty, type: :boolean, default: false,
                   desc: 'Passed to "version create" command'
    def create(version = nil)
      version ||= Version.new([], options).invoke(:create)
      release = github.create_release(tag: version, notes: release_notes)
      run "open \'#{release['html_url']}\'"
    end

    desc 'preview', 'Create release notes since latest release'
    def preview
      puts release_notes
    end

    private

    include Github

    def release_notes
      issues = github.fixed_issues_closed_since_last_release
      notes = []
      github.group_issues_by_labels(issues).each do |label, label_issues|
        notes << "## #{label}"
        notes << ''
        label_issues.each do |issue|
          notes << Issues.format_issue(issue, markdown: false)
        end
        notes << ''
      end
      notes.join "\n"
    end

    include Run

  end

end

require 'thor'
require 'git'
require 'awesome_print'
require_relative '../issues'
require_relative '../run'
require_relative '../github_client/github_client'

module Calypso

  class Release < Thor

    desc 'create', 'Create new release'
    def create
      puts release_notes
    end

    desc 'release_notes', 'Create release notes since latest release'
    def release_notes
      issues = github.fixed_issues_closed_since_last_release
      notes = []
      github.group_issues_by_labels(issues).each do |label, label_issues|
        notes << "## label: #{label}"
        notes << ''
        label_issues.each do |issue|
          notes << Issues.format_issue(issue, markdown: false)
        end
        notes << ''
      end
      notes
    end

    include Github

  end

end

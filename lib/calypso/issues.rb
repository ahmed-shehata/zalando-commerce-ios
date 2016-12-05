require 'thor'

require_relative 'consts'
require_relative 'run'
require_relative 'env'
require_relative 'log'
require_relative 'github_client/github_client'

module Calypso

  class Issues < Thor

    desc 'clean_closed', "Removes closed issues from projects [#{CLEANABLE_GITHUB_PROJECT_COLUMNS}]"
    def clean_closed
      CLEANABLE_GITHUB_PROJECT_COLUMNS.each do |project_name, columns|
        columns.each do |column_name|
          clear(project_name, column_name)
        end
      end
    end

    desc 'labeled [label1,label2] [open*,closed,any]', 'Shows available open issues with given list of labels'
    def labeled(labels = nil, state = 'open')
      github.issues(labels: labels, state: state).each do |issue|
        puts self.class.format_issue(issue)
      end
    end

    desc 'project <project_name> [column_name] [open,closed*,any]', 'Shows issues in given project / column'
    def project(project_name, column_name = nil, state = 'closed')
      github.project_issues(project_name: project_name, column_name: column_name, state: state).each do |issue|
        puts self.class.format_issue(issue)
      end
    end

    desc 'clear <project_name> <column_name>', 'Clear issues in given project / column'
    def clear(project_name, column_name)
      log "Issues in \"#{project_name}/#{column_name}\":"

      issues = column_issues_with_cards(project_name: project_name, column_name: column_name)
      log issues.map { |issue| "  * #{issue['title']} - #{issue['html_url']}\n" }

      confirm_msg = "Do you want to drop all #{issues.count} cards from the project's column (won't delete the issues)?"
      return unless yes?(confirm_msg, :red)

      cards = issues.map { |issue| issue['attached_card'] }
      github.drop_cards(cards)
    end

    def self.format_issue(issue, markdown: true)
      labels = issue['labels'].empty? ? '' : "[#{issue['labels'].map { |l| l['name'] }.join(',')}]"
      issue_link = if markdown
                     "#[#{issue['number']}](#{issue['html_url']})".freeze
                   else
                     "##{issue['number']}".freeze
                   end
      "* #{issue['title']} #{issue_link} #{labels}".freeze
    end

    private

    def column_issues_with_cards(project_name:, column_name:, state: 'closed')
      issues = github.project_issues(project_name: project_name, column_name: column_name, state: state)
      cards = cards_from(issues: issues, project_name: project_name, column_name: column_name)
      cards_urls = cards.map { |card| [card['content_url'], card] }.to_h

      issues.select do |issue|
        card = cards_urls[issue['url']]
        false if card.nil?
        issue['attached_card'] = card
      end
    end

    def cards_from(issues:, project_name:, column_name:)
      issues_urls = issues.map { |issue| issue['url'] }
      github.column_cards(project_name: project_name, column_name: column_name).select do |card|
        issues_urls.include? card['content_url']
      end
    end

    include Env
    include Log
    include Github

  end

end

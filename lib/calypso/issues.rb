require 'thor'

require_relative 'consts'
require_relative 'run'
require_relative 'env'
require_relative 'github_client/github_client'

module Calypso

  class Issues < Thor

    desc 'clean_closed', "Removes closed issues from projects [#{CLEANABLE_GITHUB_PROJECT_COLUMNS}]"
    def clean_closed
      CLEANABLE_GITHUB_PROJECT_COLUMNS.each do |project, columns|
        columns.each do |column|
          invoke :clear, [project, column]
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
      cards = github.column_cards(project_name: project_name, column_name: column_name)
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

    include Env
    include Github

  end

end

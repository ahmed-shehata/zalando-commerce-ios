require 'thor'

require_relative 'consts'
require_relative 'run'
require_relative 'env'
require_relative 'github_client/github_client'

module Calypso

  class Issues < Thor

    desc 'labeled [label1,label2] [open*,closed,any]', 'Shows available open issues with given list of labels'
    def labeled(labels = nil, state = 'open')
      github.issues(labels: labels, state: state).each do |issue|
        format_issue(issue)
      end
    end

    desc 'project <project_name> [column_name] [open,closed*,any]', 'Shows issues in given project / column'
    def project(project_name, column_name = nil, state = 'closed')
      github.project_issues(project_name: project_name, column_name: column_name, state: state).each do |issue|
        format_issue(issue)
      end
    end

    desc 'clear <project_name> <column_name>', 'Clear issues in given project / column'
    def clear(project_name, column_name)
      cards = github.column_cards(project_name: project_name, column_name: column_name)
      github.drop_cards(cards)
    end

    private

    def format_issue(issue)
      labels = issue['labels'].empty? ? '' : "[#{issue['labels'].map { |l| l['name'] }.join(',')}]"
      puts "* #{issue['title']} #[#{issue['number']}](#{issue['html_url']}) #{labels}".freeze
    end

    include Env
    include Github

  end

end

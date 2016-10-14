require 'thor'
require 'httparty'

require_relative 'consts'
require_relative 'run'
require_relative 'env'
require_relative 'github'

module Calypso

  class Issues < Thor

    desc 'list [label1,label2] [state=open,closed,any]', 'Shows available open issues with given list of labels'
    def list(labels = nil, state = 'open')
      issues(labels, state).each do |issue|
        format_issue(issue)
      end
    end

    desc 'release_notes <project_name> <column_name>', 'Shows issues in given project / column'
    def release_notes(project_name, column_name)
      column_issues(project_name, column_name).each do |issue|
        format_issue(issue)
      end
    end

    private

    def format_issue(issue)
      labels = issue['labels'].empty? ? '' : "[#{issue['labels'].map { |l| l['name'] }.join(',')}]"
      puts "* #{issue['title']} #[#{issue['number']}](#{issue['url']}) #{labels}".freeze
    end

    include Env
    include GithubClient

  end

end

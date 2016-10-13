require 'thor'
require 'httparty'

require_relative 'consts'
require_relative 'run'
require_relative 'env'

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
      cards_url(project_name, column_name)
    end

    private

    def repos_url(owner, repo, endpoint)
      "https://api.github.com/repos/#{owner}/#{repo}/#{endpoint}"
    end

    def issues_url(labels, state, owner, repo)
      repos_url(owner, repo, 'issues') + "?per_page=1000&labels=#{labels}&state=#{state}"
    end

    def projects_url(owner, repo)
      repos_url(owner, repo, 'projects')
    end

    def columns_url(project_id, owner, repo)
      repos_url(owner, repo, "projects/#{project_id}/columns")
    end

    def cards_url(project_name, column_name)
      project = project(project_name)
      column = column(project, column_name)

      puts repos_url(env_owner, env_repo, "project/columns/#{column['id']}/cards")
    end

    def issues(labels, state)
      url = issues_url(labels, state, env_owner, env_repo)
      fetch(url).select { |issue| issue['pull_request'].nil? }
    end

    def project(name)
      projects = fetch_projects(projects_url(env_owner, env_repo))
      projects.select { |p| p['name'] == name }.first
    end

    def column(project, name)
      columns = fetch_projects(columns_url(project['number'], env_owner, env_repo))
      columns.select { |c| c['name'] == name }.first
    end

    def fetch_projects(url)
      headers = { 'Accept' => 'application/vnd.github.inertia-preview+json', 'User-Agent' => 'calypso.rb' }
      fetch(url, headers)
    end

    def fetch(url, headers = nil)
      puts "Fetching #{url}..."
      response = HTTParty.get(url, headers: headers)
      response.parsed_response
    end

    def format_issue(issue)
      labels = issue['labels'].empty? ? '' : "[#{issue['labels'].map { |l| l['name'] }.join(',')}]"
      puts "* #{issue['title']} #[#{issue['number']}](#{issue['url']}) #{labels}".freeze
    end

    include Env

  end

end

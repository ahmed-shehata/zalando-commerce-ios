require 'github_api'
require_relative 'env'

module Calypso

  module GithubClient

    def issues(labels, state, pages = 10)
      fetch(issues_url, query: { labels: labels, state: state }, pages: pages).select { |issue| issue['pull_request'].nil? }
    end

    def project(name)
      projects = fetch_projects(projects_url)
      projects.select { |p| p['name'] == name }.first
    end

    def column(project, name)
      columns = fetch_projects(columns_url(project['number']))
      columns.select { |c| c['name'] == name }.first
    end

    def cards(project_name, column_name)
      fetch_projects(cards_url(project_name, column_name))
    end

    def column_issues(project_name, column_name)
      issues_ids = cards(project_name, column_name).map do |card|
        issue_url = card['content_url']
        issue_url[/http.*[^0-9]([0-9]+)$/, 1].to_i
      end
      issues = issues(nil, 'closed')
      issues.select { |i| issues_ids.include?(i['number']) }
    end

    private

    include Env

    def fetch_projects(url)
      fetch(url, new_headers: { 'Accept' => 'application/vnd.github.inertia-preview+json' })
    end

    def fetch(url, new_headers: {}, query: {}, pages: 1)
      headers = new_headers
      headers['Authorization'] = "token #{env_oauth_token}"
      headers['User-Agent'] = 'calypso.rb'

      full_response = nil
      1.upto(pages).each do |page|
        if pages > 1
          query['per_page'] = 100
          query['page'] = page
        end
        puts "Fetching #{url} ... (page=#{page})"
        response = HTTParty.get(url, headers: headers, query: query)
        parsed = response.parsed_response
        if full_response.nil?
          full_response = parsed
        else
          full_response += parsed
        end
        break if parsed.count == 0
      end
      # puts full_response
      full_response
    end

    def repos_url(endpoint, owner = env_owner, repo = env_repo)
      "https://api.github.com/repos/#{owner}/#{repo}/#{endpoint}"
    end

    def issues_url
      repos_url('issues')
    end

    def projects_url
      repos_url('projects')
    end

    def columns_url(project_id)
      repos_url("projects/#{project_id}/columns")
    end

    def cards_url(project_name, column_name)
      project = project(project_name)
      column = column(project, column_name)

      repos_url("projects/columns/#{column['id']}/cards")
    end

  end

end

require 'github_api'
require 'httparty'
require 'awesome_print'

require_relative 'env'

module Calypso

  class GithubClient

    def issues(labels, state, pages = 10)
      query = { labels: labels, state: state }
      fetch(issues_url, query: query, pages: pages).select { |issue| issue['pull_request'].nil? }
    end

    def project(name)
      projects = fetch_via_projects_api(projects_url)
      projects.select { |p| p['name'] == name }.first
    end

    def project_issues(project_name:, column_name: nil, state: 'closed')
      project = project(project_name)
      column = column_name ? column(project, column_name) : nil
      issues_ids = cards(project: project, column: column).map do |card|
        issue_url = card['content_url']
        next if issue_url.nil?
        issue_url[/http.*[^0-9]([0-9]+)$/, 1].to_i
      end.compact
      issues = issues(nil, state)
      issues.select { |i| issues_ids.include?(i['number']) }
    end

    def column_cards(project_name:, column_name:)
      project = project(project_name)
      column = column(project, column_name)
      fetch_via_projects_api(cards_url(column))
    end

    def drop_cards(cards)
      return unless yes?("Do you want to drop all #{cards.count} cards?", :red)

      cards.each do |card|
        delete_via_projects_api(delete_card_url(card))
      end
    end

    private

    def column(project, name)
      columns(project).select { |c| c['name'] == name }.first
    end

    def columns(project)
      fetch_via_projects_api(columns_url(project['number']))
    end

    def cards(project:, column: nil)
      if column.nil?
        cards = []
        columns(project).each do |col|
          print "#{col['name']} > "
          column_cards = cards(project: project, column: col)
          cards += column_cards
        end
        cards
      else
        fetch_via_projects_api(cards_url(column))
      end
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

    def cards_url(column)
      repos_url("projects/columns/#{column['id']}/cards")
    end

    def delete_card_url(card)
      repos_url("projects/columns/cards/#{card['id']}")
    end

    def fetch_via_projects_api(url)
      fetch(url, headers: { 'Accept' => 'application/vnd.github.inertia-preview+json' })
    end

    def fetch(url, headers: {}, query: {}, pages: 1)
      headers['Authorization'] = "token #{env_oauth_token}"
      headers['User-Agent'] = 'calypso.rb'

      fetch_pages(url, headers, query, pages)
    end

    def fetch_pages(url, headers, query, pages)
      full_response = []
      1.upto(pages).each do |page|
        puts "GET #{url} ... (page=#{page})"
        if pages > 1
          query['per_page'] = 100
          query['page'] = page
        end
        response = HTTParty.get(url, headers: headers, query: query)
        parsed = response.parsed_response
        full_response += parsed
        break if parsed.count.zero?
      end
      full_response
    end

    def delete_via_projects_api(url)
      delete(url, headers: { 'Accept' => 'application/vnd.github.inertia-preview+json' })
    end

    def delete(url, headers: {}, query: {})
      puts "DELETE #{url} ..."
      headers['Authorization'] = "token #{env_oauth_token}"
      headers['User-Agent'] = 'calypso.rb'

      HTTParty.delete(url, headers: headers, query: query)
    end

    include Env

  end

end

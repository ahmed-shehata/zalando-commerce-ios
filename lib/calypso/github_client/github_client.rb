require 'github_api'
require 'httparty'
require 'awesome_print'

require_relative '../env'
require_relative 'projects_api'
require_relative 'issues_api'

module Calypso

  module GithubClient

    class Client

      include IssuesAPI
      include ProjectsAPI

      private

      def api_url(api_module, owner, repo, endpoint)
        "https://api.github.com/#{api_module}/#{owner}/#{repo}/#{endpoint}"
      end

      def repos_url(endpoint, owner: env_owner, repo: env_repo)
        api_url('repos', owner, repo, endpoint)
      end

      def fetch(url, headers: {}, query: {}, pages: 1)
        headers['Authorization'] = "token #{env_oauth_token}"
        headers['User-Agent'] = 'calypso.rb'
        headers['Accept'] = 'application/vnd.github.inertia-preview+json'

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

end

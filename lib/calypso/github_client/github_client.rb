require 'github_api'
require 'httparty'
require 'awesome_print'

require_relative '../env'
require_relative '../log'
require_relative 'projects_api'
require_relative 'issues_api'
require_relative 'releases_api'

module Calypso

  module Github

    def github
      @github ||= GithubClient::Client.new
    end

  end

  module GithubClient

    class Client

      include IssuesAPI
      include ProjectsAPI
      include ReleasesAPI

      private

      def api_url(path:)
        "https://api.github.com/#{path}"
      end

      def repos_url(endpoint, owner: env_owner, repo: env_repo)
        api_url(path: "repos/#{owner}/#{repo}/#{endpoint}")
      end

      def fetch(url, headers: {}, query: {}, pages: 1)
        headers.merge! standard_headers
        fetch_pages(url, headers, query, pages)
      end

      def fetch_pages(url, headers, query, pages, per_page: 100)
        full_response = []
        1.upto(pages).each do |page|
          log_debug "GET #{url} ... (page=#{page})"
          if pages > 1
            query['per_page'] = per_page
            query['page'] = page
          end
          response = HTTParty.get(url, headers: headers, query: query, verify: verify_ssl)
          log_abort response unless response.success?
          parsed = response.parsed_response
          full_response += parsed
          break if parsed.count.zero? || parsed.count < per_page
        end
        full_response
      end

      def delete(url, headers: {}, query: {})
        log_debug "DELETE #{url} ..."
        headers.merge! standard_headers
        response = HTTParty.delete(url, headers: headers, query: query, verify: verify_ssl)
        log_abort response unless response.success?
        response
      end

      def post(url, headers: {}, query: {}, body: {})
        log_debug "POST #{url} ..."
        headers.merge! standard_headers
        response = HTTParty.post(url, headers: headers, query: query, body: body.to_json, verify: verify_ssl)
        log_abort response unless response.success?
        response
      end

      def standard_headers
        headers = {}
        headers['Authorization'] = "token #{env_oauth_token}"
        headers['User-Agent'] = 'calypso.rb'
        headers['Content-Type'] = 'application/json'
        headers['Accept'] = 'application/vnd.github.inertia-preview+json'
        headers
      end

      def verify_ssl
        false
      end

      include Env
      include Log

    end

  end

end

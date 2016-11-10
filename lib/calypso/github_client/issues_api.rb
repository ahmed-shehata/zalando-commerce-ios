module Calypso

  module GithubClient

    module IssuesAPI

      def issues(labels, state, pages = 10)
        query = { labels: labels, state: state }
        fetch(issues_url, query: query, pages: pages).select { |issue| issue['pull_request'].nil? }
      end

      private

      def issues_url
        repos_url('issues')
      end

    end

  end

end

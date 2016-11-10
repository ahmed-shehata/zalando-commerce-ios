module Calypso

  module GithubClient

    module IssuesAPI

      def issues(labels: nil, state: nil, filter: nil, sort: nil, direction: nil, since: nil, pages: 10)
        query = {}
        query['labels'] = labels unless labels.nil?
        query['state'] = state unless state.nil?
        query['sort'] = sort unless sort.nil?
        query['direction'] = direction unless direction.nil?
        query['since'] = since unless since.nil?
        query['filter'] = filter unless filter.nil?
        fetch(issues_url, query: query, pages: pages).select { |issue| issue['pull_request'].nil? }
      end

      private

      def issues_url
        repos_url('issues')
      end

    end

  end

end

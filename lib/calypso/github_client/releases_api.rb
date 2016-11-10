module Calypso

  module GithubClient

    module ReleasesAPI

      def releases
        fetch(releases_url, pages: 10).select { |issue| issue['pull_request'].nil? }
      end

      private

      def releases_url
        repos_url('releases')
      end

    end

  end

end

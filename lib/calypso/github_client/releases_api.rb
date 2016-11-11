module Calypso

  module GithubClient

    module ReleasesAPI

      def releases
        fetch(releases_url, pages: 10).select { |issue| issue['pull_request'].nil? }
      end

      def create_release(tag:, notes:)
        post(releases_url, body: { tag_name: tag, body: notes, draft: true })
      end

      def latest_release
        @latest_release ||= releases.sort { |left, right| left['created_at'] <=> right['created_at'] }.last
      end

      def latest_release_date
        DateTime.parse(latest_release['created_at'])
      end

      def fixed_issues_closed_since_last_release
        issues(since: latest_release_date.to_s, state: 'closed').select do |i|
          issue_fixed? i
        end
      end

      private

      def releases_url
        repos_url('releases')
      end

      def issue_fixed?(issue)
        fixed = issue['labels'].select { |l| l['name'] == 'wontfix' }.count.zero?
        DateTime.parse(issue['closed_at']) > latest_release_date && fixed
      end

    end

  end

end

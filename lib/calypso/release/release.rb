require 'thor'
require 'git'
require 'awesome_print'
require_relative '../run'
require_relative '../github_client/github_client'

module Calypso

  class Release < Thor

    desc 'create', 'Create new release with'
    def create
      ap issues_closed_since_last_release
    end

    private

    include Github

    def latest_release
      @latest_release ||= github.releases.sort { |left, right| left['created_at'] <=> right['created_at'] }.last
    end

    def latest_release_date
      latest_release['created_at']
    end

    def issues_closed_since_last_release
      github.issues(since: latest_release_date, state: 'closed').map { |i| i['title'] }
    end

  end

end

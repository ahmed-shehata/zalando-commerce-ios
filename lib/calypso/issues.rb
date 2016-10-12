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

    private

    def github_url(labels, state, owner, repo)
      "https://api.github.com/repos/#{owner}/#{repo}/issues?per_page=1000&labels=#{labels}&state=#{state}"
    end

    def issues(labels, state)
      url = github_url(labels, state, env_owner, env_repo)
      response = HTTParty.get(url)
      response.parsed_response.select { |issue| issue['pull_request'].nil? }
    end

    def format_issue(issue)
      labels = issue['labels'].empty? ? '' : "[#{issue['labels'].map { |l| l['name'] }.join(',')}]"
      puts "* #{issue['title']} #[#{issue['number']}](#{issue['url']}) #{labels}".freeze
    end

    include Env

  end

end

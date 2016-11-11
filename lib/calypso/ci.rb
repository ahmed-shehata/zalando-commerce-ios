require 'thor'
require 'daemons'
require 'github_api'

require_relative 'coverage'
require_relative 'env'

module Calypso

  class BuddyBuildCI < Thor

    desc 'notify_with_coverage', 'Created status accordingly to code coverage result'
    def notify_with_coverage
      report = Coverage.new.invoke(:check)
      change = report[:change]
      coverage = report[:current]
      msg = "Build passed. #{report[:msg]}"
      if change <= COV_THRESHOLD_FAIL
        invoke :failure, [msg]
      elsif change <= COV_THRESHOLD_WARN || coverage < MIN_CODE_COVERAGE
        invoke :pending, [msg]
      else
        invoke :success, [msg]
      end
    end

    desc 'success [message]', "Creates 'success' status"
    def success(message = nil)
      notify('success', message)
    end

    desc 'pending [message]', "Creates 'pending' status"
    def pending(message = nil)
      notify('pending', message)
    end

    desc 'failure [message]', "Creates 'failure' status"
    def failure(message = nil)
      notify('failure', message)
    end

    desc 'error [message]', "Creates 'error' status"
    def error(message = nil)
      notify('error', message)
    end

    desc 'notify_on_push', "Notify after 'git push' is completed"
    def notify_on_push
      env_owner || env_repo || env_rev_sha # check for existing env values
      wait_for_finish('git push$') do
        notify('pending', 'Commit pushed')
      end
    end

    private

    def notify(status, message)
      log "Status updated: #{status} - '#{message}'"
      begin
        t = Time.now
        tz = t.dst? ? '+02:00' : '+01:00'
        tf = t.localtime(tz).strftime('%T, %d/%b')
        github.repos.statuses.create env_owner, env_repo, env_rev_sha,
          context: 'buddybuild',
          state: status,
          target_url: target_url,
          description: "#{message} (#{tf})"
      rescue StandardError => e
        abort "ERROR updating status: #{e}"
      end
    end

    def target_url
      return nil if env_app_id.nil? || env_build_id.nil?
      "https://dashboard.buddybuild.com/apps/#{env_app_id}/build/#{env_build_id}"
    end

    def wait_for_finish(pattern, timeout = 30, step = 0.5)
      @task = Daemons.call do
        steps = 0
        loop do
          output = `ps -A|grep -E '#{pattern}'|sort -n|tail -1|cut -f 1 -d ' '`
          if output.length.zero?
            yield
            @task.stop
          end

          sleep(step)
          steps += step
          @task.stop if step >= timeout
        end
      end
    end

    include Env

    def github
      @github ||= Github.new do |config|
        config.endpoint    = env_endpoint
        config.oauth_token = env_oauth_token
      end
    end

  end

end

module Calypso

  module Env

    def env_owner
      ENV['GITHUB_OWNER'] ||
        log_abort('ERROR: No $GITHUB_OWNER')
    end

    def env_repo
      ENV['GITHUB_REPO'] ||
        log_abort('ERROR: No $GITHUB_REPO')
    end

    def env_endpoint
      ENV['GITHUB_ENDPOINT'] ||
        log_abort('ERROR: No $GITHUB_ENDPOINT')
    end

    def env_oauth_token
      ENV['GITHUB_OAUTH_TOKEN'] ||
        log_abort('ERROR: No $GITHUB_OAUTH_TOKEN')
    end

    def env_rev_sha
      ENV['GIT_REVISION_SHA'] ||
        log_abort('ERROR: No $GIT_REVISION_SHA')
    end

    def env_build_id
      ENV['BUDDYBUILD_BUILD_ID']
    end

    def env_app_id
      ENV['BUDDYBUILD_APP_ID']
    end

    def env_skip_xcpretty?
      ENV['ATLAS_SKIP_XCPRETTY'] == 'true'
    end

  end

end

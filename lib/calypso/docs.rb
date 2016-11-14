require 'thor'

module Calypso

  class Docs < Thor

    desc 'build', 'Generate documentation'
    def build
      system 'jazzy'
    end

    desc 'changelog', 'Generate CHANGELOG'
    def changelog
      system 'github_changelog_generator -t ' + env_changelog_token
    end

    private

    def env_changelog_token
      ENV['CHANGELOG_GITHUB_TOKEN'] ||
        log_abort('ERROR: No $CHANGELOG_GITHUB_TOKEN in your env')
    end

  end

end

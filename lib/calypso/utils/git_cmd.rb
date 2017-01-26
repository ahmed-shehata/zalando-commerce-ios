require 'git'

module Calypso

  module GitCmd

    def repo
      @repo ||= Git.open(File.expand_path('../../../..', __FILE__))
    end

    def master_branch?
      current_branch == 'master'
    end

    def current_branch
      `git rev-parse --abbrev-ref HEAD`.strip
    end

  end

end

require 'English'
require_relative 'log'

module Calypso

  module Run

    def run(cmd, exit_on_failure: true, silent: false)
      log_debug "CMD: #{cmd}" unless silent

      system(cmd)
      exitstatus = $CHILD_STATUS.exitstatus
      exit(exitstatus) if exit_on_failure && !$CHILD_STATUS.success?
      exitstatus
    end

    include Log

  end

end

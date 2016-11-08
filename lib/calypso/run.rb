require 'English'

module Calypso

  module Run

    def run(cmd, exit_on_failure: true, silent: false)
      puts "CMD: #{cmd}" unless silent

      system(cmd)
      exitstatus = $CHILD_STATUS.exitstatus
      exit(exitstatus) if exit_on_failure && !$CHILD_STATUS.success?
      exitstatus
    end

  end

end

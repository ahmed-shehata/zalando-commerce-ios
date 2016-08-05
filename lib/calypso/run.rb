require 'English'

module Calypso

  module Run

    def run(cmd)
      puts "CMD: #{cmd}"
      system(cmd)
      exit($CHILD_STATUS.exitstatus) unless $CHILD_STATUS.success?
    end

  end

end

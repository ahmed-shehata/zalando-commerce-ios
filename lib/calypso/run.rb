module Calypso

  module Run

    def run(cmd)
      puts "CMD: #{cmd}"
      system cmd
    end

  end

end

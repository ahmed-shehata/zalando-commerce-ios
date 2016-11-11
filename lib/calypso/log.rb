require 'thor'

module Calypso

  module Log

    def log(*args)
      color(code: 32) { puts args }
    end

    def log_debug(*args)
      color(code: 33) { STDERR.puts args }
    end

    def color(code:)
      printf "\033[#{code}m"
      yield
      printf "\033[0m"
    end

  end

end

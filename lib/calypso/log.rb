require 'thor'

module Calypso

  module Log

    def log(*args)
      print_color_on_tty(STDOUT, 32, args)
    end

    def log_debug(*args)
      print_color_on_tty(STDERR, 33, args)
    end

    def log_warn(*args)
      print_color_on_tty(STDOUT, 31, args)
    end

    def log_exit(*args)
      print_color_on_tty(STDOUT, 31, args)
      exit(0)
    end

    def log_abort(*args)
      print_color_on_tty(STDOUT, 31, args)
      abort
    end

    private

    def print_color_on_tty(io, color_code, *args)
      if io.isatty
        ansi_color(code: color_code) { io.puts args }
      else
        io.puts args
      end
    end

    def ansi_color(code:)
      printf "\033[#{code}m"
      yield
      printf "\033[0m"
    end

  end

end

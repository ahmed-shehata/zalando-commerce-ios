require 'thor'

module Calypso

  module Log

    def log(*args, color: '32')
      print_color_on_tty(STDOUT, color, args)
    end

    def log_debug(*args)
      print_color_on_tty(STDERR, '33', args)
    end

    def log_warn(*args)
      print_color_on_tty(STDOUT, '31', args)
    end

    def log_exit(*args)
      print_color_on_tty(STDOUT, '31', args)
      exit(0)
    end

    def log_abort(*args)
      print_color_on_tty(STDOUT, '31', args)
      abort
    end

    def ansi_color(str, color:)
      "\033[#{color}m#{str}\033[0m"
    end

    private

    def print_color_on_tty(io, color_code, *args)
      if io.isatty
        io.printf "\033[#{color_code}m"
        io.puts args
        io.printf "\033[0m"
      else
        io.puts args
      end
    end

  end

end

class String
  def color(color)
    "\033[#{color}m#{self}\033[0m"
  end
end

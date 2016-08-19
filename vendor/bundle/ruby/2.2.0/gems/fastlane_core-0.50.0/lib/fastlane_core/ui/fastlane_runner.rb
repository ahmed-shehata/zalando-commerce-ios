module Commander
  # This class override the run method with our custom stack trace handling
  # In particular we want to distinguish between user_error! and crash! (one with, one without stack trace)
  class Runner
    unless Object.const_defined?("Faraday")
      module Faraday
        class SSLError < StandardError
          # We create this empty error class if we didn't require Faraday
          # so that we can use it in the rescue block below
          # even if we didn't require Faraday or didn't use it
        end
      end
    end

    # Code taken from https://github.com/commander-rb/commander/blob/master/lib/commander/runner.rb#L50
    def run!
      require_program :version, :description
      trap('INT') { abort program(:int_message) } if program(:int_message)
      trap('INT') { program(:int_block).call } if program(:int_block)
      global_option('-h', '--help', 'Display help documentation') do
        args = @args - %w(-h --help)
        command(:help).run(*args)
        return
      end
      global_option('-v', '--version', 'Display version information') do
        say version
        return
      end
      parse_global_options
      remove_global_options options, @args

      collector = FastlaneCore::ToolCollector.new

      begin
        collector.did_launch_action(@program[:name])
        run_active_command
      rescue InvalidCommandError => e
        abort "#{e}. Use --help for more information"
      rescue Interrupt => ex
        # We catch it so that the stack trace is hidden by default when using ctrl + c
        if $verbose
          raise ex
        else
          puts "\nCancelled... use --verbose to show the stack trace"
        end
      rescue \
        OptionParser::InvalidOption,
        OptionParser::InvalidArgument,
        OptionParser::MissingArgument => e
        abort e.to_s
      rescue FastlaneCore::Interface::FastlaneError => e # user_error!
        collector.did_raise_error(@program[:name])
        show_github_issues(e.message) if e.show_github_issues
        display_user_error!(e, e.message)
      rescue Faraday::SSLError => e # SSL issues are very common
        # SSL errors are very common when the Ruby or OpenSSL installation is somehow broken
        # We want to show a nice error message to the user here
        # We have over 20 GitHub issues just for this one error:
        #   https://github.com/fastlane/fastlane/search?q=errno%3D0+state%3DSSLv3+read+server&type=Issues
        ui = FastlaneCore::UI
        ui.error "-----------------------------------------------------------------------"
        ui.error e.to_s
        ui.error "SSL errors can be caused by various components on your local machine"
        ui.error "- Make sure OpenSSL is installed with Homebrew: `brew update && brew upgrade openssl`"
        ui.error "- If you use rvm:"
        ui.error "  - First run `rvm osx-ssl-certs update all`"
        ui.error "  - Then run `rvm reinstall ruby-2.2.3 --with-openssl-dir=/usr/local"
        ui.error "- If that doesn't fix your issue, please google for the following error message:"
        ui.error "  '#{e}'"
        ui.error "-----------------------------------------------------------------------"
        display_user_error!(e, e.to_s)
      rescue => e # high chance this is actually FastlaneCore::Interface::FastlaneCrash, but can be anything else
        collector.did_crash(@program[:name])
        handle_unknown_error!(e)
      ensure
        collector.did_finish
      end
    end

    def handle_unknown_error!(e)
      # Some spaceship exception classes implement #preferred_error_info in order to share error info
      # that we'd rather display instead of crashing with a stack trace. However, fastlane_core and
      # spaceship can not know about each other's classes! To make this information passing work, we
      # use a bit of Ruby duck-typing to check whether the unknown exception type implements the right
      # method. If so, we'll present any returned error info in the manner of a user_error!
      error_info = e.respond_to?(:preferred_error_info) ? e.preferred_error_info : nil

      if error_info
        error_info = error_info.join("\n\t") if error_info.kind_of?(Array)

        show_github_issues(error_info)

        display_user_error!(e, error_info)
      else
        # Pass the error instead of a message so that the inspector can do extra work to simplify the query
        show_github_issues(e)

        # From https://stackoverflow.com/a/4789702/445598
        # We do this to make the actual error message red and therefore more visible
        reraise_formatted!(e, e.message)
      end
    end

    def display_user_error!(e, message)
      if $verbose # with stack trace
        reraise_formatted!(e, message)
      else
        abort "\n[!] #{message}".red # without stack trace
      end
    end

    def reraise_formatted!(e, message)
      raise e, "[!] #{message}".red, e.backtrace
    end

    def show_github_issues(message_or_error)
      return if ENV["FASTLANE_HIDE_GITHUB_ISSUES"]
      return if FastlaneCore::Helper.test?

      require 'gh_inspector'
      require 'fastlane_core/ui/github_issue_inspector_reporter'

      inspector = GhInspector::Inspector.new("fastlane", "fastlane", verbose: $verbose)
      delegate = Fastlane::InspectorReporter.new
      if message_or_error.kind_of?(String)
        inspector.search_query(message_or_error, delegate)
      else
        inspector.search_exception(message_or_error, delegate)
      end
    rescue => ex
      FastlaneCore::UI.error("Error finding relevant GitHub issues: #{ex}")
    end
  end
end

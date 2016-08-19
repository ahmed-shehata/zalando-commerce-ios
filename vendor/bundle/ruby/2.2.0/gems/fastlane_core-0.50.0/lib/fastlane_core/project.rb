module FastlaneCore
  # Represents an Xcode project
  class Project
    class << self
      # Project discovery
      def detect_projects(config)
        if config[:workspace].to_s.length > 0 and config[:project].to_s.length > 0
          UI.user_error!("You can only pass either a workspace or a project path, not both")
        end

        return if config[:project].to_s.length > 0

        if config[:workspace].to_s.length == 0
          workspace = Dir["./*.xcworkspace"]
          if workspace.count > 1
            puts "Select Workspace: "
            config[:workspace] = choose(*workspace)
          elsif !workspace.first.nil?
            config[:workspace] = workspace.first
          end
        end

        return if config[:workspace].to_s.length > 0

        if config[:workspace].to_s.length == 0 and config[:project].to_s.length == 0
          project = Dir["./*.xcodeproj"]
          if project.count > 1
            puts "Select Project: "
            config[:project] = choose(*project)
          elsif !project.first.nil?
            config[:project] = project.first
          end
        end

        if config[:workspace].nil? and config[:project].nil?
          select_project(config)
        end
      end

      def select_project(config)
        loop do
          path = ask("Couldn't automatically detect the project file, please provide a path: ".yellow).strip
          if File.directory? path
            if path.end_with? ".xcworkspace"
              config[:workspace] = path
              break
            elsif path.end_with? ".xcodeproj"
              config[:project] = path
              break
            else
              UI.error("Path must end with either .xcworkspace or .xcodeproj")
            end
          else
            UI.error("Couldn't find project at path '#{File.expand_path(path)}'")
          end
        end
      end
    end

    # Path to the project/workspace
    attr_accessor :path

    # Is this project a workspace?
    attr_accessor :is_workspace

    # The config object containing the scheme, configuration, etc.
    attr_accessor :options

    # Should the output of xcodebuild commands be silenced?
    attr_accessor :xcodebuild_list_silent

    # Should we redirect stderr to /dev/null for xcodebuild commands?
    # Gets rid of annoying plugin info warnings.
    attr_accessor :xcodebuild_suppress_stderr

    def initialize(options, xcodebuild_list_silent: false, xcodebuild_suppress_stderr: false)
      self.options = options
      self.path = File.expand_path(options[:workspace] || options[:project])
      self.is_workspace = (options[:workspace].to_s.length > 0)
      self.xcodebuild_list_silent = xcodebuild_list_silent
      self.xcodebuild_suppress_stderr = xcodebuild_suppress_stderr

      if !path or !File.directory?(path)
        UI.user_error!("Could not find project at path '#{path}'")
      end
    end

    def workspace?
      self.is_workspace
    end

    def project_name
      if is_workspace
        return File.basename(options[:workspace], ".xcworkspace")
      else
        return File.basename(options[:project], ".xcodeproj")
      end
    end

    # Get all available schemes in an array
    def schemes
      parsed_info.schemes
    end

    # Let the user select a scheme
    # Use a scheme containing the preferred_to_include string when multiple schemes were found
    def select_scheme(preferred_to_include: nil)
      if options[:scheme].to_s.length > 0
        # Verify the scheme is available
        unless schemes.include?(options[:scheme].to_s)
          UI.error("Couldn't find specified scheme '#{options[:scheme]}'.")
          options[:scheme] = nil
        end
      end

      return if options[:scheme].to_s.length > 0

      if schemes.count == 1
        options[:scheme] = schemes.last
      elsif schemes.count > 1
        preferred = nil
        if preferred_to_include
          preferred = schemes.find_all { |a| a.downcase.include?(preferred_to_include.downcase) }
        end

        if preferred_to_include and preferred.count == 1
          options[:scheme] = preferred.last
        elsif automated_scheme_selection? && schemes.include?(project_name)
          UI.important("Using scheme matching project name (#{project_name}).")
          options[:scheme] = project_name
        elsif Helper.is_ci?
          UI.error("Multiple schemes found but you haven't specified one.")
          UI.error("Since this is a CI, please pass one using the `scheme` option")
          UI.user_error!("Multiple schemes found")
        else
          puts "Select Scheme: "
          options[:scheme] = choose(*schemes)
        end
      else
        UI.error("Couldn't find any schemes in this project, make sure that the scheme is shared if you are using a workspace")
        UI.error("Open Xcode, click on `Manage Schemes` and check the `Shared` box for the schemes you want to use")

        UI.user_error!("No Schemes found")
      end
    end

    # Get all available configurations in an array
    def configurations
      parsed_info.configurations
    end

    # Returns bundle_id and sets the scheme for xcrun
    def default_app_identifier
      default_build_settings(key: "PRODUCT_BUNDLE_IDENTIFIER")
    end

    # Returns app name and sets the scheme for xcrun
    def default_app_name
      if is_workspace
        return default_build_settings(key: "PRODUCT_NAME")
      else
        return app_name
      end
    end

    def app_name
      # WRAPPER_NAME: Example.app
      # WRAPPER_SUFFIX: .app
      name = build_settings(key: "WRAPPER_NAME")

      return name.gsub(build_settings(key: "WRAPPER_SUFFIX"), "") if name
      return "App" # default value
    end

    def mac?
      # Some projects have different values... we have to look for all of them
      return true if build_settings(key: "PLATFORM_NAME") == "macosx"
      return true if build_settings(key: "PLATFORM_DISPLAY_NAME") == "macOS"
      return true if build_settings(key: "PLATFORM_DISPLAY_NAME") == "OS X"
      false
    end

    def tvos?
      return true if build_settings(key: "PLATFORM_NAME").to_s.include? "appletv"
      return true if build_settings(key: "PLATFORM_DISPLAY_NAME").to_s.include? "tvOS"
      false
    end

    def ios?
      !mac? && !tvos?
    end

    def xcodebuild_parameters
      proj = []
      proj << "-workspace #{options[:workspace].shellescape}" if options[:workspace]
      proj << "-scheme #{options[:scheme].shellescape}" if options[:scheme]
      proj << "-project #{options[:project].shellescape}" if options[:project]

      return proj
    end

    #####################################################
    # @!group Raw Access
    #####################################################

    def build_xcodebuild_showbuildsettings_command
      # We also need to pass the workspace and scheme to this command
      command = "xcodebuild -showBuildSettings #{xcodebuild_parameters.join(' ')}"
      command += " 2> /dev/null" if xcodebuild_suppress_stderr
      command
    end

    # Get the build settings for our project
    # this is used to properly get the DerivedData folder
    # @param [String] The key of which we want the value for (e.g. "PRODUCT_NAME")
    def build_settings(key: nil, optional: true)
      unless @build_settings
        command = build_xcodebuild_showbuildsettings_command
        @build_settings = Helper.backticks(command, print: false)
      end

      begin
        result = @build_settings.split("\n").find { |c| c.split(" = ").first.strip == key }
        return result.split(" = ").last
      rescue => ex
        return nil if optional # an optional value, we really don't care if something goes wrong

        UI.error(caller.join("\n\t"))
        UI.error("Could not fetch #{key} from project file: #{ex}")
      end

      nil
    end

    # Returns the build settings and sets the default scheme to the options hash
    def default_build_settings(key: nil, optional: true)
      options[:scheme] = schemes.first if is_workspace
      build_settings(key: key, optional: optional)
    end

    def build_xcodebuild_list_command
      # Unfortunately since we pass the workspace we also get all the
      # schemes generated by CocoaPods
      options = xcodebuild_parameters.delete_if { |a| a.to_s.include? "scheme" }
      command = "xcodebuild -list #{options.join(' ')}"
      command += " 2> /dev/null" if xcodebuild_suppress_stderr
      command
    end

    def raw_info(silent: false)
      # Examples:

      # Standard:
      #
      # Information about project "Example":
      #     Targets:
      #         Example
      #         ExampleUITests
      #
      #     Build Configurations:
      #         Debug
      #         Release
      #
      #     If no build configuration is specified and -scheme is not passed then "Release" is used.
      #
      #     Schemes:
      #         Example
      #         ExampleUITests

      # CococaPods
      #
      # Example.xcworkspace
      # Information about workspace "Example":
      #     Schemes:
      #         Example
      #         HexColors
      #         Pods-Example

      return @raw if @raw

      command = build_xcodebuild_list_command
      UI.important(command) unless silent

      # xcode >= 6 might hang here if the user schemes are missing
      begin
        timeout = FastlaneCore::Project.xcode_list_timeout
        @raw = FastlaneCore::Project.run_command(command, timeout: timeout)
      rescue Timeout::Error
        UI.user_error!("xcodebuild -list timed-out after #{timeout} seconds. You might need to recreate the user schemes." \
          " You can override the timeout value with the environment variable FASTLANE_XCODE_LIST_TIMEOUT")
      end

      UI.user_error!("Error parsing xcode file using `#{command}`") if @raw.length == 0

      return @raw
    end

    # @internal to module
    def self.xcode_list_timeout
      (ENV['FASTLANE_XCODE_LIST_TIMEOUT'] || 10).to_i
    end

    # @internal to module
    # runs the specified command and kills it if timeouts
    # @raises Timeout::Error if timeout is passed
    # @returns the output
    # Note: currently affected by fastlane/fastlane_core#102
    def self.run_command(command, timeout: 0)
      require 'timeout'
      @raw = Timeout.timeout(timeout) { `#{command}`.to_s }
    end

    private

    def parsed_info
      unless @parsed_info
        @parsed_info = FastlaneCore::XcodebuildListOutputParser.new(raw_info(silent: xcodebuild_list_silent))
      end
      @parsed_info
    end

    # If scheme not specified, do we want the scheme
    # matching project name?
    def automated_scheme_selection?
      !!ENV["AUTOMATED_SCHEME_SELECTION"]
    end
  end
end

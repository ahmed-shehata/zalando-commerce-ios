module CredentialsManager
  # Access the content of the app file (e.g. app identifier and Apple ID)
  class AppfileConfig

    def self.try_fetch_value(key)
      begin
        return self.new.data[key]
      rescue => ex
        puts ex.to_s
        return nil
      end
      nil
    end

    def self.default_path
      ["./fastlane/Appfile", "./.fastlane/Appfile", "./Appfile"].each do |current|
        return current if File.exist? current
      end
      nil
    end

    def initialize(path = nil)
      if path
        raise "Could not find Appfile at path '#{path}'".red unless File.exist?(path)
      end

      path ||= self.class.default_path

      if path and File.exist?(path) # it might not exist, we still want to use the default values
        full_path = File.expand_path(path)
        Dir.chdir(File.expand_path('..', path)) do
          content = File.read(full_path)

          # From https://github.com/orta/danger/blob/master/lib/danger/Dangerfile.rb
          if content.tr!('“”‘’‛', %(""'''))
            puts "Your #{File.basename(path)} has had smart quotes sanitised. " \
                 'To avoid issues in the future, you should not use ' \
                 'TextEdit for editing it. If you are not using TextEdit, ' \
                 'you should turn off smart quotes in your editor of choice.'.red
          end

          # rubocop:disable Lint/Eval
          eval(content)
          # rubocop:enable Lint/Eval
        end
      end

      fallback_to_default_values
    end

    def fallback_to_default_values
      data[:apple_id] ||= ENV["FASTLANE_USER"] || ENV["DELIVER_USER"]
    end

    def data
      @data ||= {}
    end

    # Setters

    # iOS
    def app_identifier(*args, &block)
      setter(:app_identifier, *args, &block)
    end

    def apple_id(*args, &block)
      setter(:apple_id, *args, &block)
    end

    def apple_dev_portal_id(*args, &block)
      setter(:apple_dev_portal_id, *args, &block)
    end

    def itunes_connect_id(*args, &block)
      setter(:itunes_connect_id, *args, &block)
    end

    # Developer Portal
    def team_id(*args, &block)
      setter(:team_id, *args, &block)
    end

    def team_name(*args, &block)
      setter(:team_name, *args, &block)
    end

    # iTunes Connect
    def itc_team_id(*args, &block)
      setter(:itc_team_id, *args, &block)
    end

    def itc_team_name(*args, &block)
      setter(:itc_team_name, *args, &block)
    end

    # Android
    def json_key_file(*args, &block)
      setter(:json_key_file, *args, &block)
    end

    def issuer(*args, &block)
      puts "Appfile: DEPRECATED issuer: use json_key_file instead".red
      setter(:issuer, *args, &block)
    end

    def package_name(*args, &block)
      setter(:package_name, *args, &block)
    end

    def keyfile(*args, &block)
      puts "Appfile: DEPRECATED keyfile: use json_key_file instead".red
      setter(:keyfile, *args, &block)
    end

    # Override Appfile configuration for a specific lane.
    #
    # lane_name  - Symbol representing a lane name. (Can be either :name, 'name' or 'platform name')
    # block - Block to execute to override configuration values.
    #
    # Discussion If received lane name does not match the lane name available as environment variable, no changes will
    #             be applied.
    def for_lane(lane_name)
      if lane_name.to_s.split(" ").count > 1
        # That's the legacy syntax 'platform name'
        puts "You use deprecated syntax '#{lane_name}' in your Appfile.".yellow
        puts "Please follow the Appfile guide: https://github.com/fastlane/fastlane/blob/master/docs/Appfile.md".yellow
        platform, lane_name = lane_name.split(" ")

        return unless platform == ENV["FASTLANE_PLATFORM_NAME"]
        # the lane name will be verified below
      end

      if ENV["FASTLANE_LANE_NAME"] == lane_name.to_s
        yield
      end
    end

    # Override Appfile configuration for a specific platform.
    #
    # platform_name  - Symbol representing a platform name.
    # block - Block to execute to override configuration values.
    #
    # Discussion If received paltform name does not match the platform name available as environment variable, no changes will
    #             be applied.
    def for_platform(platform_name)
      if ENV["FASTLANE_PLATFORM_NAME"] == platform_name.to_s
        yield
      end
    end

    private

    def setter(key, *args)
      if block_given?
        value = yield
      else
        value = args.shift
      end
      data[key] = value if value && value.to_s.length > 0
    end
  end
end

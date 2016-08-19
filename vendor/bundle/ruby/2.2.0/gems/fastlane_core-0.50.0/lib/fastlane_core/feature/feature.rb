module FastlaneCore
  class Feature
    class << self
      attr_reader :features

      def register(env_var: nil, description: nil)
        feature = self.new(description: description, env_var: env_var)
        @features[feature.env_var] = feature
      end

      def enabled?(env_var)
        feature = @features[env_var]
        return false if feature.nil?
        return false if ENV[feature.env_var] == '0' # '0' is a non-falsey value that should indicate feature switch disabled
        return ENV[feature.env_var] # rely on the truthiness of the value set in the environment variable
      end

      def register_class_method(klass: nil, symbol: nil, disabled_symbol: nil, enabled_symbol: nil, env_var: nil)
        return if klass.nil? || symbol.nil? || disabled_symbol.nil? || enabled_symbol.nil? || env_var.nil?
        klass.define_singleton_method(symbol) do |*args|
          if Feature.enabled?(env_var)
            klass.send(enabled_symbol, *args)
          else
            klass.send(disabled_symbol, *args)
          end
        end
      end

      def register_instance_method(klass: nil, symbol: nil, disabled_symbol: nil, enabled_symbol: nil, env_var: nil)
        return if klass.nil? || symbol.nil? || disabled_symbol.nil? || enabled_symbol.nil? || env_var.nil?
        klass.send(:define_method, symbol.to_s) do |*args|
          if Feature.enabled?(env_var)
            send(enabled_symbol, *args)
          else
            send(disabled_symbol, *args)
          end
        end
      end
    end

    @features = {}

    attr_reader :env_var, :description
    def initialize(env_var: nil, description: nil)
      raise "Invalid Feature" if env_var.nil? || description.nil?
      @env_var = env_var
      @description = description
    end
  end
end

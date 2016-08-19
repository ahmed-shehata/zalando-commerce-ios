# frozen_string_literal: true
require 'yaml'

module Reek
  #
  # A comment header from an abstract syntax tree; found directly above
  # module, class and method definitions.
  #
  class CodeComment
    CONFIGURATION_REGEX            = /:reek:(\w+)(:\s*\{.*?\})?/
    SANITIZE_REGEX                 = /(#|\n|\s)+/ # Matches '#', newlines and > 1 whitespaces.
    DISABLE_DETECTOR_CONFIGURATION = ': { enabled: false }'.freeze
    MINIMUM_CONTENT_LENGTH         = 2

    attr_reader :config

    #
    # @param comment [String] - the original comment as found in the source code
    #   E.g.:
    #   "\n        # :reek:Duplication: { enabled: false }\n      "
    #
    def initialize(comment)
      @original_comment  = comment
      @config            = Hash.new { |hash, key| hash[key] = {} }

      @original_comment.scan(CONFIGURATION_REGEX) do |smell_type, options|
        @config.merge! YAML.load(smell_type + (options || DISABLE_DETECTOR_CONFIGURATION))
      end
    end

    def descriptive?
      sanitized_comment.split(/\s+/).length >= MINIMUM_CONTENT_LENGTH
    end

    private

    attr_reader :original_comment

    def sanitized_comment
      @sanitized_comment ||= original_comment.
        gsub(CONFIGURATION_REGEX, '').
        gsub(SANITIZE_REGEX, ' ').
        strip
    end
  end
end

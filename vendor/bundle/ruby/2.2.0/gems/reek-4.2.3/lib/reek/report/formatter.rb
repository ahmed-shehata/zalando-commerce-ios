# frozen_string_literal: true
require_relative 'location_formatter'
require_relative 'code_climate/code_climate_formatter'

module Reek
  module Report
    #
    # Formatter handling the formatting of the report at large.
    # Formatting of the individual warnings is handled by the
    # passed-in warning formatter.
    #
    module Formatter
      module_function

      def format_list(warnings, formatter: SimpleWarningFormatter.new)
        warnings.map { |warning| "  #{formatter.format(warning)}" }.join("\n")
      end

      def header(examiner)
        count = examiner.smells_count
        result = Rainbow("#{examiner.description} -- ").cyan +
          Rainbow("#{count} warning").yellow
        result += Rainbow('s').yellow unless count == 1
        result
      end
    end

    #
    # Basic formatter that just shows a simple message for each warning,
    # prepended with the result of the passed-in location formatter.
    #
    class SimpleWarningFormatter
      def initialize(location_formatter: BlankLocationFormatter)
        @location_formatter = location_formatter
      end

      def format(warning)
        "#{location_formatter.format(warning)}#{warning.base_message}"
      end

      # :reek:UtilityFunction
      def format_hash(warning)
        warning.yaml_hash
      end

      # :reek:UtilityFunction
      def format_code_climate_hash(warning)
        CodeClimateFormatter.new(warning).render
      end

      private

      attr_reader :location_formatter
    end

    #
    # Formatter that adds a link to the wiki to the basic message from
    # SimpleWarningFormatter.
    #
    class WikiLinkWarningFormatter < SimpleWarningFormatter
      BASE_URL_FOR_HELP_LINK = 'https://github.com/troessner/reek/blob/master/docs/'.freeze

      def format(warning)
        "#{super} [#{explanatory_link(warning)}]"
      end

      def format_hash(warning)
        super.merge('wiki_link' => explanatory_link(warning))
      end

      private

      def explanatory_link(warning)
        "#{BASE_URL_FOR_HELP_LINK}#{class_name_to_param(warning.smell_type)}.md"
      end

      # :reek:UtilityFunction
      def class_name_to_param(name)
        name.split(/(?=[A-Z])/).join('-')
      end
    end
  end
end

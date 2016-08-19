# encoding: utf-8
# frozen_string_literal: true

module RuboCop
  module Cop
    module Rails
      # This cop checks for the use of output safety calls like html_safe and
      # raw.
      #
      # @example
      #   # bad
      #   "<p>#{text}</p>".html_safe
      #
      #   # good
      #   content_tag(:p, text)
      #
      #   # bad
      #   out = ""
      #   out << content_tag(:li, "one")
      #   out << content_tag(:li, "two")
      #   out.html_safe
      #
      #   # good
      #   out = []
      #   out << content_tag(:li, "one")
      #   out << content_tag(:li, "two")
      #   safe_join(out)
      #
      class OutputSafety < Cop
        MSG = 'Tagging a string as html safe may be a security risk, ' \
              'prefer `safe_join` or other Rails tag helpers instead'.freeze

        def on_send(node)
          receiver, method_name, *_args = *node

          if receiver && method_name == :html_safe
            add_offense(node, :selector)
          elsif receiver.nil? && method_name == :raw
            add_offense(node, :selector)
          end
        end
      end
    end
  end
end

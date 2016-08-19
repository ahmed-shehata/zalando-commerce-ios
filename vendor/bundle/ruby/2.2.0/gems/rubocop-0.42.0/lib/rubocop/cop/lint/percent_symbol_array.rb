# encoding: utf-8
# frozen_string_literal: true

module RuboCop
  module Cop
    module Lint
      # This cop checks for colons and commas in %i, e.g.
      #
      #   `%i(:foo, :bar)`
      #
      # it is more likely that the additional characters are unintended (for
      # example, mistranslating an array of literals to percent string notation)
      # rather than meant to be part of the resulting symbols.
      class PercentSymbolArray < Cop
        include PercentLiteral

        MSG = "Within `%i`/`%I`, ':' and ',' are unnecessary and may be " \
          'unwanted in the resulting symbols.'.freeze

        def on_array(node)
          process(node, *%w(%i %I))
        end

        def on_percent_literal(node)
          if contains_colons_or_commas?(node)
            add_offense(node, :expression, MSG)
          end
        end

        private

        def contains_colons_or_commas?(node)
          patterns = [/^:/, /,$/]
          node.children.any? do |child|
            literal = child.children.first

            # To avoid likely false positives (e.g. a single ' or ")
            next if literal.to_s.gsub(/[^\p{Alnum}]/, '').empty?

            patterns.any? { |pat| literal =~ pat }
          end
        end

        def autocorrect(node)
          lambda do |corrector|
            node.children.each do |child|
              range = child.loc.expression

              corrector.remove_trailing(range, 1) if /,$/ =~ range.source
              corrector.remove_leading(range, 1) if /^:/ =~ range.source
            end
          end
        end
      end
    end
  end
end

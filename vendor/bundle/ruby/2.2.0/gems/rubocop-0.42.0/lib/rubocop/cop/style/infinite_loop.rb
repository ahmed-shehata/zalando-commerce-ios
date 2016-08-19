# encoding: utf-8
# frozen_string_literal: true

module RuboCop
  module Cop
    module Style
      # Use `Kernel#loop` for infinite loops.
      #
      # @example
      #   # bad
      #   while true
      #     work
      #   end
      #
      #   # good
      #   loop do
      #     work
      #   end
      class InfiniteLoop < Cop
        MSG = 'Use `Kernel#loop` for infinite loops.'.freeze

        def on_while(node)
          condition, = *node
          return unless condition.truthy_literal?

          add_offense(node, :keyword)
        end

        def on_until(node)
          condition, = *node
          return unless condition.falsey_literal?

          add_offense(node, :keyword)
        end

        alias on_while_post on_while
        alias on_until_post on_until

        def autocorrect(node)
          if node.while_post_type? || node.until_post_type?
            _, body = *node
            return lambda do |corrector|
              corrector.replace(body.loc.begin, 'loop do')
              corrector.remove(body.loc.end.end.join(node.source_range.end))
            end
          end

          if node.modifier_form?
            range = node.source_range
            replacement = modifier_replacement(node)
          else
            range = non_modifier_range(node)
            replacement = 'loop do'
          end

          ->(corrector) { corrector.replace(range, replacement) }
        end

        private

        def modifier_replacement(node)
          _, body = *node
          if node.single_line?
            'loop { ' + body.source + ' }'
          else
            indentation = body.loc.expression.source_line[/\A(\s*)/]
            "loop do\n" + indentation +
              body.source.gsub(/^/, ' ' * configured_indentation_width) +
              "\n#{indentation}end"
          end
        end

        def non_modifier_range(node)
          condition_node, = *node
          start_range = node.loc.keyword.begin
          end_range = if node.loc.begin
                        node.loc.begin.end
                      else
                        condition_node.source_range.end
                      end
          start_range.join(end_range)
        end

        def configured_indentation_width
          config.for_cop('IndentationWidth')['Width']
        end
      end
    end
  end
end

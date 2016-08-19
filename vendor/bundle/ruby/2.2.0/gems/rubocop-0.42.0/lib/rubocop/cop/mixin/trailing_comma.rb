# encoding: utf-8
# frozen_string_literal: true

module RuboCop
  module Cop
    # Common methods shared by Style/TrailingCommaInArguments and
    # Style/TrailingCommaInLiteral
    module TrailingComma
      include ConfigurableEnforcedStyle

      MSG = '%s comma after the last %s'.freeze

      def parameter_name
        'EnforcedStyleForMultiline'
      end

      def check(node, items, kind, begin_pos, end_pos)
        sb = node.source_range.source_buffer
        after_last_item = Parser::Source::Range.new(sb, begin_pos, end_pos)

        return if heredoc?(after_last_item.source)

        comma_offset = after_last_item.source =~ /,/

        if comma_offset && !inside_comment?(after_last_item, comma_offset)
          check_comma(node, kind, after_last_item.begin_pos + comma_offset)
        elsif should_have_comma?(style, node)
          put_comma(node, items, kind, sb)
        end
      end

      def check_comma(node, kind, comma_pos)
        return if should_have_comma?(style, node)

        avoid_comma(kind, comma_pos, node.source_range.source_buffer,
                    extra_avoid_comma_info)
      end

      def extra_avoid_comma_info
        case style
        when :comma
          ', unless each item is on its own line'
        when :consistent_comma
          ', unless items are split onto multiple lines'
        else
          ''
        end
      end

      def should_have_comma?(style, node)
        case style
        when :comma
          multiline?(node) && no_elements_on_same_line?(node)
        when :consistent_comma
          multiline?(node)
        else
          false
        end
      end

      def inside_comment?(range, comma_offset)
        processed_source.comments.any? do |comment|
          comment_offset = comment.loc.expression.begin_pos - range.begin_pos
          comment_offset >= 0 && comment_offset < comma_offset
        end
      end

      def heredoc?(source_after_last_item)
        source_after_last_item =~ /\w/
      end

      # Returns true if the node has round/square/curly brackets.
      def brackets?(node)
        node.loc.end
      end

      # Returns true if the round/square/curly brackets of the given node are
      # on different lines, and each item within is on its own line, and the
      # closing bracket is on its own line.
      def multiline?(node)
        # No need to process anything if the whole node is not multiline
        # Without the 2nd check, Foo.new({}) is considered multiline, which
        # it should not be. Essentially, if there are no elements, the
        # expression can not be multiline.
        return false unless node.multiline?

        items = elements(node).map(&:source_range)
        return false if items.empty?
        items << node.loc.begin << node.loc.end
        (items.map(&:first_line) + items.map(&:last_line)).uniq.count > 1
      end

      def elements(node)
        return node.children unless node.send_type?

        _receiver, _method_name, *args = *node
        args.flat_map do |a|
          # For each argument, if it is a multi-line hash without braces,
          # then promote the hash elements to method arguments
          # for the purpose of determining multi-line-ness.
          if a.hash_type? && a.loc.first_line != a.loc.last_line &&
             !brackets?(a)
            a.children
          else
            a
          end
        end
      end

      def no_elements_on_same_line?(node)
        items = elements(node).map(&:source_range)
        items << node.loc.end
        items.each_cons(2).none? { |a, b| on_same_line?(a, b) }
      end

      def on_same_line?(a, b)
        a.last_line == b.line
      end

      def avoid_comma(kind, comma_begin_pos, sb, extra_info)
        range = Parser::Source::Range.new(sb, comma_begin_pos,
                                          comma_begin_pos + 1)
        article = kind =~ /array/ ? 'an' : 'a'
        add_offense(range, range,
                    format(MSG, 'Avoid', format(kind, article)) +
                    "#{extra_info}.")
      end

      def put_comma(node, items, kind, sb)
        last_item = items.last
        return if last_item.type == :block_pass

        last_expr = last_item.source_range
        ix = last_expr.source.rindex("\n") || 0
        ix += last_expr.source[ix..-1] =~ /\S/
        range = Parser::Source::Range.new(sb, last_expr.begin_pos + ix,
                                          last_expr.end_pos)
        autocorrect_range = avoid_autocorrect?(elements(node)) ? nil : range

        add_offense(autocorrect_range, range,
                    format(MSG, 'Put a', format(kind, 'a multiline') + '.'))
      end

      # By default, there's no reason to avoid auto-correct.
      def avoid_autocorrect?(_)
        false
      end

      def autocorrect(range)
        return unless range

        lambda do |corrector|
          case range.source
          when ',' then corrector.remove(range)
          else          corrector.insert_after(range, ',')
          end
        end
      end
    end
  end
end

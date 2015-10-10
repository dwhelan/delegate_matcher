# encoding: utf-8

module RuboCop
  module Cop
    module Style
      # This cop checks for extra/unnecessary whitespace.
      #
      # @example
      #
      #   # good if AllowForAlignment is true
      #   name      = "RuboCop"
      #   # Some comment and an empty line
      #
      #   website  += "/bbatsov/rubocop" unless cond
      #   puts        "rubocop"          if     debug
      #
      #   # bad for any configuration
      #   set_app("RuboCop")
      #   website  = "https://github.com/bbatsov/rubocop"
      class ExtraSpacing < Cop
        MSG = 'Unnecessary spacing detected.'

        def investigate(processed_source)
          processed_source.tokens.each_cons(2) do |t1, t2|
            next if t2.type == :tNL
            next if t1.pos.line != t2.pos.line
            next if t2.pos.begin_pos - 1 <= t1.pos.end_pos
            next if allow_for_alignment? && aligned_with_something?(t2)
            start_pos = t1.pos.end_pos
            end_pos = t2.pos.begin_pos - 1
            range = Parser::Source::Range.new(processed_source.buffer,
                                              start_pos, end_pos)
            add_offense(range, range, MSG)
          end
        end

        def autocorrect(range)
          ->(corrector) { corrector.remove(range) }
        end

        private

        def allow_for_alignment?
          cop_config['AllowForAlignment']
        end

        def aligned_with_something?(token)
          return aligned_comments?(token) if token.type == :tCOMMENT

          pre = (token.pos.line - 2).downto(0)
          post = token.pos.line.upto(processed_source.lines.size - 1)
          aligned_with?(pre, token) || aligned_with?(post, token)
        end

        def aligned_comments?(token)
          ix = processed_source.comments.index do |c|
            c.loc.expression.begin_pos == token.pos.begin_pos
          end
          aligned_with_previous_comment?(ix) || aligned_with_next_comment?(ix)
        end

        def aligned_with_previous_comment?(ix)
          ix > 0 && comment_column(ix - 1) == comment_column(ix)
        end

        def aligned_with_next_comment?(ix)
          ix < processed_source.comments.length - 1 &&
            comment_column(ix + 1) == comment_column(ix)
        end

        def comment_column(ix)
          processed_source.comments[ix].loc.column
        end

        def aligned_with?(indices_to_check, token)
          indices_to_check.each do |ix|
            next if comment_lines.include?(ix + 1)
            line = processed_source.lines[ix]
            next if line.strip.empty?
            return (aligned_words?(token, line) ||
                    aligned_assignments?(token, line) ||
                    aligned_same_character?(token, line))
          end
          false # No line to check was found.
        end

        def comment_lines
          @comment_lines ||=
            begin
              whole_line_comments = processed_source.comments.select do |c|
                begins_its_line?(c.loc.expression)
              end
              whole_line_comments.map(&:loc).map(&:line)
            end
        end

        def aligned_words?(token, line)
          line[token.pos.column - 1, 2] =~ /\s\S/
        end

        def aligned_assignments?(token, line)
          token.type == :tOP_ASGN &&
            line[token.pos.column + token.text.length] == '='
        end

        def aligned_same_character?(token, line)
          line[token.pos.column] == token.text[0]
        end
      end
    end
  end
end

require "test_helper"
require "lexer"

class LexerTest < Test::Unit::TestCase
  def test_comment
    assert_equal [[:NUMBER, 16]], Lexer.new.tokenize("16 % I wonder what is that for..")
  end

  def test_number
    assert_equal [[:NUMBER, 1]], Lexer.new.tokenize("1")
    assert_equal [[:NUMBER, 12345]], Lexer.new.tokenize("12345")
  end

  def test_string
    assert_equal [[:STRING, "ahoy"]], Lexer.new.tokenize('"ahoy"')
  end

  def test_identifier
    assert_equal [[:IDENTIFIER, "name"]], Lexer.new.tokenize('name')
  end

  def test_constant
    assert_equal [[:CONSTANT, "Captain"]], Lexer.new.tokenize('Captain')
  end

  def test_operator
    assert_equal [["+", "+"]], Lexer.new.tokenize('+')
  end

  def test_block
    code = <<-CODE
if true
  rawr("Ahoy!")

  if true
    rawr("Sea!")
  ends
ends
CODE

    tokens = [
      [:IF, "if"], [:TRUE, "true"],
      [:NEWLINE, "\n"],
        [:IDENTIFIER, "rawr"], ["(", "("], [:STRING, "Ahoy!"], [")", ")"],
        [:NEWLINE, "\n"],
        [:NEWLINE, "\n"],
        [:IF, "if"], [:TRUE, "true"],
        [:NEWLINE, "\n"],
          [:IDENTIFIER, "rawr"], ["(", "("], [:STRING, "Sea!"], [")", ")"],
          [:NEWLINE, "\n"],
        [:ENDS, "ends"],
        [:NEWLINE, "\n"],
      [:ENDS, "ends"]
    ]

    assert_equal tokens, Lexer.new.tokenize(code)
  end
end

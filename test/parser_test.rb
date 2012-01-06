require "test_helper"
require "parser"

class ParserTest < Test::Unit::TestCase
  def test_comment
    assert_equal Nodes.new([TrueNode.new]), Parser.new.parse("true % I tell you")
  end

  def test_unary
    assert_equal Nodes.new([CallNode.new(TrueNode.new(), "!", [])]), Parser.new.parse("!true")
    assert_equal Nodes.new([CallNode.new(FalseNode.new(), "!", [])]), Parser.new.parse("!false")
    assert_equal Nodes.new([CallNode.new(NilNode.new(), "!", [])]), Parser.new.parse("!nil")
  end

  def test_number
    assert_equal Nodes.new([NumberNode.new(1)]), Parser.new.parse("1")
  end

  def test_expression
    assert_equal Nodes.new([NumberNode.new(1), StringNode.new("ay")]), Parser.new.parse(%{1\n"ay"})
  end

  def test_call
    assert_equal Nodes.new([CallNode.new(NumberNode.new(1), "time", [])]), Parser.new.parse("1.time")
  end

  def test_call_with_args
    assert_equal Nodes.new([CallNode.new(nil, "ayay", [NumberNode.new(1), NumberNode.new(2)])]), Parser.new.parse("ayay(1, 2)")
  end

  def test_assign
    assert_equal Nodes.new([SetLocalNode.new("a", NumberNode.new(1))]), Parser.new.parse("a = 1")
    assert_equal Nodes.new([SetConstantNode.new("A", NumberNode.new(1))]), Parser.new.parse("A = 1")
  end

  def test_def
    code = <<-CODE
matey ay
  true
ends
CODE

    nodes = Nodes.new([
              DefNode.new("ay", [],
                Nodes.new([TrueNode.new])
              )
    ])

    assert_equal nodes, Parser.new.parse(code)
  end

  def test_def_with_param
    code = <<-CODE
matey ay(a, b)
  true
ends
CODE

    nodes = Nodes.new([
              DefNode.new("ay", ["a", "b"],
                Nodes.new([TrueNode.new])
              )
    ])

    assert_equal nodes, Parser.new.parse(code)
  end

  def test_class
    code = <<-CODE
ship QueenAnnesRevenge
  true
ends
CODE

    nodes = Nodes.new([
              ClassNode.new("QueenAnnesRevenge",
                Nodes.new([TrueNode.new])
              )
    ])

    assert_equal nodes, Parser.new.parse(code)
  end

  def test_arithmetic
    nodes = Nodes.new([
              CallNode.new(NumberNode.new(1), "+", [
                CallNode.new(NumberNode.new(2), "*", [NumberNode.new(3)])
              ])
    ])

    assert_equal nodes, Parser.new.parse("1 + 2 * 3")
    assert_equal nodes, Parser.new.parse("1 + (2 * 3)")
  end

  def xtest_binary_operator
    nodes = Nodes.new([
              CallNode.new(
                CallNode.new(NumberNode.new(1), "+", [NumberNode.new(2)]),
                  "||", [NumberNode.new(3)]
              )
    ])

    assert_equal nodes, Parser.new.parse("1 + 2 || 3")
  end

  def xtest_unary_operator
    nodes = Nodes.new([
              CallNode.new(NumberNode.new(2), "!", [])
    ])

    assert_equal nodes, Parser.new.parse("!2")
  end

  def test_if
    code = <<-CODE
if true
  nil
ends
CODE

    nodes = Nodes.new([
              IfNode.new(TrueNode.new,
                Nodes.new([NilNode.new])
              )
    ])

    assert_equal nodes, Parser.new.parse(code)
  end
end

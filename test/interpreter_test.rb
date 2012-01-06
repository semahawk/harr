require "test_helper"
require "interpreter"

class InterpreterTest < Test::Unit::TestCase
  def test_comment
    assert_equal 4, Interpreter.new.eval("a = 8 + 4 - 8; a % Could have done it better but its midnight.").ruby_value
  end

  def test_number
    assert_equal 1, Interpreter.new.eval("1").ruby_value
  end

  def test_true
    assert_equal true, Interpreter.new.eval("true").ruby_value
  end

  def test_unary
    assert_equal false, Interpreter.new.eval("!true").ruby_value
    assert_equal true, Interpreter.new.eval("!nil").ruby_value
    assert_equal true, Interpreter.new.eval("!false").ruby_value
  end

  def test_assign
    assert_equal 2, Interpreter.new.eval("a = 2; 3; a").ruby_value
  end

  def test_method
    code = <<-CODE
matey rawr(a)
  a
ends

rawr("Yarr!")
CODE

    assert_equal "Yarr!", Interpreter.new.eval(code).ruby_value
  end

  def test_reopen_class
    code = <<-CODE
ship Number
  matey ten
    10
  ends
ends

1.ten
CODE

    assert_equal 10, Interpreter.new.eval(code).ruby_value
  end

  def test_define_class
    code = <<-CODE
ship Barrel
  matey explodes
    true 
  ends
ends

Barrel.new.explodes
CODE

    assert_equal true, Interpreter.new.eval(code).ruby_value
  end

  def test_if
    code = <<-CODE
if true
  "Ayay!"
ends
CODE

    assert_equal "Ayay!", Interpreter.new.eval(code).ruby_value
  end

  def test_interpret
    code = <<-CODE
ship Blackbeard
  matey sails
    "Adventure Time!"
  ends
ends

object = Blackbeard.new
if object
  rawr(object.sails)
ends
CODE

    assert_prints("Nodes\nAdventure Time!\n") { Interpreter.new.eval(code) }
  end
end


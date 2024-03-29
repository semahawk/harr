require "test_helper"
require "runtime"

class RuntimeTest < Test::Unit::TestCase
  def test_get_constant
    assert_not_nil Runtime["Object"]
  end

  def test_create_an_object
    assert_equal Runtime["Object"], Runtime["Object"].new.runtime_class
  end

  def test_create_an_object_mapped_to_ruby_value
    assert_equal 32, Runtime["Number"].new_with_value(32).ruby_value
  end

  def test_lookup_method_in_class
    assert_not_nil Runtime["Object"].lookup("rawr")
    assert_raise(RuntimeError) { Runtime["Object"].lookup("no-doubt-there-is-no-such-a-method") }
  end

  def test_call_method
    obj = Runtime["Object"].call("new")

    assert_equal Runtime["Object"], obj.runtime_class
  end

  def test_a_class_is_a_class
    assert_equal Runtime["Class"], Runtime["Number"].runtime_class
  end
end


require "parser"
require "runtime"

class Interpreter
  def initialize(show_tokens = false)
    @parser = Parser.new
    @show_tokens = show_tokens
  end

  def eval(code)
    @parser.parse(code, @show_tokens).eval(Runtime)
  end
end

class Nodes
  # This method is the "intepreter" part of our language. All nodes know how to eval
  # itself and returns the result of its evaluation by implementing the `eval` method.
  # The "context" variable is the environment in which the node is evaluated (local
  # variables, current class, etc.).
  def eval(context)
    return_value = nil
    nodes.each do |node|
      return_value = node.eval(context)
    end
    # The last value evaluated in a method is the return value. Or nil if none.
    return_value || Runtime["nil"]
  end
end

class NumberNode
  def eval(context)
    Runtime["Number"].new_with_value(value)
  end
end

class StringNode
  def eval(context)
    Runtime["String"].new_with_value(value)
  end
end

class TrueNode
  def eval(context)
    Runtime["true"]
  end
end

class FalseNode
  def eval(context)
    Runtime["false"]
  end
end

class NilNode
  def eval(context)
    Runtime["nil"]
  end
end

class CallNode
  def eval(context)
    # If there is no reciever and the method name is the name of local var, then
    # it's a local var access. This trick allow us to skip the ()s when calling a
    # method
    if receiver.nil? && context.locals[method] && arguments.empty?
      context.locals[method]
    else
      if receiver
        value = receiver.eval(context)
      else
        # In case there's no reciever we default to self, calling `puts` is like
        # `self.puts`.
        value = context.current_self
      end

      eval_arguments = arguments.map { |arg| arg.eval(context) }
      value.call(method, eval_arguments)
    end
  end
end

class GetConstantNode
  def eval(context)
    context[name]
  end
end

class SetConstantNode
  def eval(context)
    context[name] = value.eval(context)
  end
end

class SetLocalNode
  def eval(context)
    context.locals[name] = value.eval(context)
  end
end

class DefNode
  def eval(context)
    # Defining a method is adding a method to the current class.
    method = HarrMethod.new(params, body)
    context.current_class.runtime_methods[name] = method
    Runtime["nil"]
  end
end

class ClassNode
  def eval(context)
    # Try to locate the class. Allows reopening classes to add methods.
    harr_class = context[name]

    unless harr_class # Doesn't exist yet
      harr_class = HarrClass.new
      # Register the class as a constant in the runtime.
      context[name] = harr_class
    end

    # Evaluate the body of the class in its context. Providing a custom context allows
    # to control where methods are added when defined with the `def` keyword.
    # In this case, we add them to the newly created class.
    class_context = Context.new(harr_class, harr_class)

    body.eval(class_context)

    Runtime["nil"]
  end
end

class IfNode
  def eval(context)
    # We turn the condition node into a Ruby value to use Ruby's `if` control structure.
    puts body.class
      if condition.eval(context).ruby_value
        body.eval(context)
      end
  end
end

class WhileNode
  def eval(context)
    unless body.empty?
      while condition.eval(context).ruby_value
        body.eval(context)
      end
    end
  end
end


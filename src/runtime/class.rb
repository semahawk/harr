# Represents a Harr class in the Ruby world. Classes are objects in Harr so they
# inherit from HarrObject.
class HarrClass < HarrObject
  attr_reader :runtime_methods

  # Creates a new class. Number is an instance of Class for example.
  def initialize(superclass = nil)
    @runtime_methods = {}
    @runtime_superclass = superclass

    # Check if we're bootstraping (launching the runtime). During this process the
    # runtime is not fully initialized and core classes do not yet exists, so we defer
    # using those once the language is bootstrapped.
    # This solves the chicken-or-the-egg problem with the Class class. We can
    # initialize Class then set Class.class = Class.
    if defined? Runtime
      runtime_class = Runtime["Class"]
    else
      runtime_class = nil
    end

    super runtime_class
  end

  # Lookup the method
  def lookup(method_name)
    method = @runtime_methods[method_name]
    unless method
      if @runtime_superclass
        return @runtime_superclass.lookup(method_name)
      else
        if Runtime["Object"].runtime_methods[method_name]
          return Runtime["Object"].lookup(method_name)
        else
          raise "Method not found: #{method_name}"
        end
      end
    end
    method
  end

  # Create a new instance of this class.
  def new
    HarrObject.new(self)
  end

  # Create an instance of this Harr class that holds a Ruby value. Like a String,
  # Number or true.
  def new_with_value(value)
    HarrObject.new(self, value)
  end
end

#Runtime["Number"] = HarrClass.new(Runtime["Object"])

# Boostrap the runtime. This is where we assemble all the classes and objects together
# to form the runtime.
#
#                                       # What's happening under the hood 

harr_class = HarrClass.new              # Class
harr_class.runtime_class = harr_class   # Class.class = Class
object_class = HarrClass.new            # Object = Class.new
object_class.runtime_class = harr_class # Object.class = Class

# Create the Runtime object (the root context) on which all code will start its
# evaluation.
Runtime = Context.new(object_class.new)

Runtime["Class"] = harr_class
Runtime["Object"] = object_class
Runtime["Number"] = HarrClass.new
Runtime["String"] = HarrClass.new

Runtime["TrueClass"] = HarrClass.new
Runtime["FalseClass"] = HarrClass.new
Runtime["NilClass"] = HarrClass.new

Runtime["true"] = Runtime["TrueClass"].new_with_value(true)
Runtime["false"] = Runtime["FalseClass"].new_with_value(false)
Runtime["nil"] = Runtime["NilClass"].new_with_value(nil)

# Add a few core methods to the runtime.
# Add the `new` method to classes, used to instantiate a class:
#   eg.: Object.new, Number.new, String.new
Runtime["Class"].runtime_methods["new"] = proc do |reciever, arguments|
  reciever.new
end

# Print an object to the console.
#   eg.: rawr("Ahoy, Sea!")
Runtime["Object"].runtime_methods["rawr"] = proc do |reciever, arguments|
  puts arguments.first.ruby_value
  Runtime["nil"]
end

Runtime["Object"].runtime_methods["loot"] = proc do |reciever, arguments|
  #raise "No such file to load '#{arguments.first.ruby_value}'" unless File.exists? arguments.first.ruby_value
  Interpreter.new.eval File.read(arguments.first.ruby_value)
  Runtime["nil"]
end

Runtime["TrueClass"].runtime_methods["!"] = proc do |reciever, arguments|
  Runtime["false"]
end

Runtime["FalseClass"].runtime_methods["!"] = proc do |reciever, arguments|
  Runtime["true"]
end

Runtime["NilClass"].runtime_methods["!"] = proc do |reciever, arguments|
  Runtime["true"]
end

Runtime["Number"].runtime_methods["+"] = proc do |receiver, arguments|
  result = receiver.ruby_value + arguments.first.ruby_value
  Runtime["Number"].new_with_value(result)
end

Runtime["Number"].runtime_methods["*"] = proc do |receiver, arguments|
  result = receiver.ruby_value * arguments.first.ruby_value
  Runtime["Number"].new_with_value(result)
end

Runtime["Number"].runtime_methods["/"] = proc do |receiver, arguments|
  result = (receiver.ruby_value.to_f / arguments.first.ruby_value.to_f).to_f
  Runtime["Number"].new_with_value(result)
end

Runtime["Number"].runtime_methods["-"] = proc do |receiver, arguments|
  result = receiver.ruby_value - arguments.first.ruby_value
  Runtime["Number"].new_with_value(result)
end


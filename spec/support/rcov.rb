
# Recursively forces autoload-declared constants to be loaded, to make sure Rcov
# is aware of these files and reports coverage on them. Otherwise, code that is
# never run nor autoloaded won't even show up on the coverage report.
#
# @note: To avoid defining a method in the global namespace or having to create
# a new namespace in which to define the method, this is a defined as a lambda
# value instead of a method.
#
if defined? Rcov or defined? SimpleCov
  lambda do |root|
    # Prevent walking in circles due to cycles in the graph
    # like Object.constants.include?("Object") #=> true
    history = Hash.new

    f = lambda do |namespace, recurse|
      history[namespace] = true

      for child in namespace.constants
        begin
          next if child.to_s == "Contrib"
          value = namespace.const_get(child)

          if value.is_a?(Module) and not history[value]
            recurse.call(value, recurse)
          end
        rescue LoadError, NameError
          $stderr.puts "warning: #{$!.class} #{$!.message}"
          $stderr.puts "   file: #{$!.backtrace.first}"
        end
      end
    end

    f.call(root, f)
  end.call(Stupidedi)
end

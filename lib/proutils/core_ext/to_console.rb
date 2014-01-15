# TODO: Improve the naming scheme of these methods.
# TODO: Replace these with facets/shellwords ?

class Array
  # Convert an array into commandline parameters.
  # The array is accepted in the format of Ruby
  # method arguments --ie. [arg1, arg2, ..., hash]
  #
  # Returns [String]

  def to_console
    #flags = (Hash===last ? pop : {})
    #flags = flags.to_console
    #flags + ' ' + join(" ")
    to_argv.join(' ')
  end

  # TODO: DEPRECATE
  alias_method :to_params, :to_console

  # Convert to argument vector. If the last element in the
  # array is a Hash then call #to_argv on it and merge results.
  #
  # Returns [Array]
  def to_argv
    flags = (Hash===last ? pop : {})
    flags = flags.to_argv
    flags + self
  end

#   def to_console
#     flags = (Hash===last ? pop : {})
#     flags = flags.collect do |f,v|
#       m = f.to_s.size == 1 ? '-' : '--'
#       case v
#       when Array
#         v.collect{ |e| "#{m}#{f} '#{e}'" }.join(' ')
#       when true
#         "#{m}#{f}"
#       when false, nil
#         ''
#       else
#         "#{m}#{f} '#{v}'"
#       end
#     end
#     return (flags + self).join(" ")
#   end

end

class Hash

  # Convert a Hash into command line arguments.
  # The array is accepted in the format of Ruby
  # method arguments --ie. [arg1, arg2, ..., hash]
  #
  # Returns [String]
  def to_console
    to_argv.join(' ')
  end

  # Convert a Hash into command line parameters.
  # The array is accepted in the format of Ruby
  # method arguments --ie. [arg1, arg2, ..., hash]
  #
  # Returns [Array]
  def to_argv
    flags = []
    each do |f,v|
      m = f.to_s.size == 1 ? '-' : '--'
      case v
      when Array
        v.each{ |e| flags << "#{m}#{f}='#{e}'" }
      when true
        flags << "#{m}#{f}"
      when false, nil
        # nothing
      else
        flags << "#{m}#{f}='#{v}'"
      end
    end
    flags
  end

  # Turn a hash into arguments.
  #
  #     h = { :list => [1,2], :base => "HI" }
  #     h.argumentize #=> [ [], { :list => [1,2], :base => "HI" } ]
  #     h.argumentize(:list) #=> [ [1,2], { :base => "HI" } ]
  #
  # Returns [Array]
  def argumentize(args_field=nil)
    config = dup
    if args_field
      args = [config.delete(args_field)].flatten.compact
    else
      args = []
    end
    args << config
    return args
  end

  # Alias for #argumentize.
  alias_method :command_vector, :argumentize

end

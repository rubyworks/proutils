module ProUtils

  require 'pathname'

  ##
  # ConfigUtils module provides an interface to configuration.
  #
  # TODO: Should these all just be globals instead? Then we don't
  #        have to fuss with passing them around. If they need to be
  #        changed for specific section of code then we can create a
  #        wrapper, e.g.
  #
  #            configure(options) do
  #              # make calls
  #            end
  #
  #        But that is not thread safe :(. Can we fix  with Mutex locks?
  #        If it wasn't for the threading question this would probably
  #        be a done deal.
  #
  module ConfigUtils

    # List of attributes.
    ATTRIBUTES = [
      :silent, :quiet, :trial, :noop, :verbose, :debug, :trace,
      :root_pattern, :file_name_policy, :stdin, :stdout, :stderr
    ]

		# FIXME: How to handle exactly?
		def configure(options, &block)
      if block
        save = options.keys.map do |k|
          [k, send(k)]
        end
      else
        options.each do |name, value|
          send("#{name}=", value) if ATTRIBUTES.include?(name.to_sym)
        end
      end
		end

    # When silent the output to $stdout is supressed.
    #
    # Returns [Boolean]
    def silent?
      $SILENT 
    end

    # Set `$SILENT` to `true` or `false`.
    def silent=(boolean)
      $SILENT = !!boolean
    end

    # Alias for `#silent?`.
    alias quiet? silent?

    # Alias for `#silent=`.
    alias quiet= silent=

    # Trace flag instructs code to show progress when significant actions
    # take place. The output should go to `$stderr`. The {StdioUtils#trace}
    # method is provided to simplify this.
    def trace?
      $TRACE
    end

    # Set `$TRACE` to `true` or `false`.
    def trace=(boolean)
      $TRACE = !!boolean
    end

    # Debug mode?
    #
    # Returns [Boolean]
    def debug?
      $DEBUG
    end

    # Set `$DEBUG` to `true` or `false`.
    def debug=(boolean)
      $DEBUG = !!boolean
    end

    # Warning level.
    #
    # Returns [nil,Integer]
    def warn?
      $WARN
    end

    # Set the warning level. It can be `false` (or `nil`) to mean
    # no warnings or any positive integer to indicate a level of warnings
    # The higher the level the more types of warnings one will see.
    #
    # Unfortunately, Ruby is a bit limited in levels, and it only 
    # natively support two levels handled as the `false` and `true`
    # values of the $VERBOSE global variable.
    #
    def warn=(level)
      $WARN = (
        case level
        when Integer
          level = level.abs
          level == 0 ? nil : level
        when true
          2
        else
          nil
        end
      )

      # Ruby's handling of warning levels.
      $VERBOSE = (
        case $WARN
        when nil, false then nil
        when 1 then false
        else true
        end
      )
    end

    #
    def noop?
      $NOOP
    end

    #
    def noop=(boolean)
      $NOOP = !!boolean
    end

    # A `dryrun` is the same a `trace` and `noop` togehter.
    def dryrun?
      trace? && noop?
    end

    #
    def dryrun=(boolean)
      self.trace = boolean
      self.noop  = boolean
    end

    # Alias for `dryrun`.
    alias trial? dryrun?
    alias trial= dryrun=

    # Access to `$stdin`.
    # 
    # Returns [IO]
    def stdin
      $stdin
    end

    #
    def stdin=(io)
      $stdin = io
    end

    # Access to `$stdout`.
    # 
    # Returns [IO]
    def stdout
      $stdout
    end

    #
    def stdout=(io)
      $stdout = io
    end

    # Access to `$stderr`.
    # 
    # Returns [IO]
    def stderr
      $stdrr
    end

    #
    def stderr=(io)
      $stderr = io
    end

    # Default project root pattern.
    $ROOT_PATTERN = "{.index,.git,.hg,.svn,_darcs}"

    # Glob for finding root of a project.
    #
    # TODO: Get the from an environment variable first?
    #
    # Returns glob string. [String]
    def root_pattern
      $ROOT_PATTERN
    end

    # The project root pattern glob.
    #
    # glob - [String] Pattern used by `Dir.glob()` to locate a
    #        project's root directory.
    #
    def root_pattern=(glob)
      $ROOT_PATTERN = glob
    end

    # Probably can do without the filename policy. But if some tool
    # saves to a file, and the default naming scheme is to the users
    # liking then they should have the option of chaning the name
    # of file explicitly. Being able to adjust the "style" of name
    # os useful then.

    # Deprecated: Default file name policy.
    $FILENAME_POLICY = [:down, :ext]

    # Deprecated: A file name policy detrmines how files that
    # have flexiable naming options are to be named exactly.
    # For instance, a file may optionally be capitialized
    # or not. A file name policy of `[:cap]` can then be used
    # to ... this is stupid.
    #
    # Returns [Array<Symbol>]
    def filename_policy
      $FILENAME_POLICY
    end

    # Deprecated: Set file name policy.
    def filename_policy=(entry)
      $FILENAME_POLICY ||= (
        Array(entry).map{ |s| s.to_s }
      )
    end

    # Force opertations that otherwise would have been skipped
    # or raised an error for catuionary reasons.
    #
    # NOTE: There is a reluctance to provide a global for the
    #   force setting. Maybe force should be on a per use basis
    #   and not a global config at all?
    #   
    # Returns [Boolean]
    def force?
      $FORCE
    end

    # Set force setting `true` or `false`.
    def force=(boolean)
      $FORCE = !!boolean
    end

  end

end

=begin
    # This allows config to be used in some places where a hash would be used.
    def [](name)
      return nil unless ATTRIBUTES.include?(name.to_sym)
      if respond_to?(name)
        send(name)
      elsif respond_to?("#{name}?")
        send("#{name}?")
      else
        nil
      end
    end

    #
    def to_h
      h = {}
      ATTRIBUTES.each do |a|
        h[a] = send(a)
      end
      h
    end
=end


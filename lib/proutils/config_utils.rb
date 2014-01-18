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

		#
		def configure(options)
		  @__config__ ||= Config.new
      @__config__.update(options)
		end

		# The utility modules themselves use this method instead
    # of the ordinary #config method to avoid any method name
    # clash.
		def __config__
		  @__config__ ||= Config.new
		end

    #
    alias config __config__

    def force?     ; __config__.force?   ; end
    def force=(b)  ; __config__.force=b  ; end

    def silent?    ; __config__.silent?  ; end
    def silent=(b) ; __config__.silent=b ; end

    def quiet?     ; __config__.quiet?   ; end
    def quiet=(b)  ; __config__.quiet=b  ; end

    def trace?     ; __config__.trace?   ; end
    def trace=(b)  ; __config__.trace=b  ; end

    def debug?     ; __config__.debug?   ; end
    def debug=(b)  ; __config__.debug=b  ; end

    def warn?      ; __config__.warn?    ; end
    def warn=(b)   ; __config__.warn=b   ; end

    def noop?      ; __config__.noop?    ; end
    def noop=(b)   ; __config__.noop=b   ; end

    def trial?     ; __config__.trial?   ; end
    def trial=(b)  ; __config__.trial=b  ; end

    def dryrun?    ; __config__.dryrun?  ; end
    def dryrun=(b) ; __config__.dryrun=b ; end

  end

  ##
  # The Config class provides a data store for various common
  # configuration settings used by other utilities.
  #
  # * silent/quiet
  # * warn
  # * debug
  # * trace
  # * force
  # * noop
  # * trial/dryrun (same as noop && trace)
  #
  # * stdout
  # * stdin
  # * stderr
  #
  # * root_pattern
  # * file_name_policy
  #
  class Config

    # SCM markers for finding a project's root directory.
    ROOT_PATTERN = "{.index,.git,.hg,.svn,_darcs}"

    # List of attributes.
    ATTRIBUTES = [
      :force, :quiet, :trial, :noop, :verbose, :debug, :trace,
      :root_pattern, :file_name_policy
    ]

    #
    def initialize(options={})
      @force   = false
		  @quiet   = false
		  @trial   = false
		  @noop    = false
      @verbose = false

      @debug   = false
      @trace   = false

      @stdout  = $stdout
      @stdin   = $stdin
      @stderr  = $stderr

      @root_pattern = ROOT_PATTERN

      @file_name_policy = ['down', 'ext']

      update(options)
    end

    # Update options.
    def update(options={})
      options.each do |k,v|
        if repsond_to?("#{k}=")
          send("#{k}=", v)
        else
          #warn "No utility configuration for #{k}."
        end
      end
    end

    # Force opertations that otherwise would have been skipped
    # or raised an error for catuionary reasons.
    #
    # NOTE: There is a reluctance to provide a global fallback for
    #   the force setting, but being consitent with all the other
    #   settings it does so.
    #   
    # Returns [Boolean]
    def force?
      @force || $FORCE
    end

    # Set force setting `true` or `false`.
    def force=(boolean)
      @force = !!boolean
    end

    # When silent the output to $stdout is supressed.
    #
    # Returns [Boolean]
    def silent?
      @silent || $SILENT
    end

    #
    def silent=(boolean)
      @silent = !!boolean
    end

    # Alias for `#silent?`.
    alias quiet? silent?

    # Alias for `#silent=`.
    alias quiet= silent=

    # Warning level.
    #
    # Returns [false,Integer]
    def warn?
      @warn || $WARN
    end

    # Warn set the warning level. It can be `false` (or `nil`) to mean
    # no warnings or any positive integer to indicate a level of warnings
    # The higher the level the more types of warnings one will see.
    #
    # Unfortunately, Ruby is a bit limited in levels, and it only 
    # natively support two levels handled as the `false` and `true`
    # values of the $VERBOSE global variable.
    #
    def warn=(level)
      @warn = (
        case level
        when Integer
          @warn = level.to_i.abs
        when True
          @warn = 0
        else
          @warn = false
        end
      )

      # Ruby's handling of warning levels
      $VERBOSE = (
        case @warn
        when nil, false then nil
        when 0 then false
        else true
        end
      )
    end

    # If `@noop` is nil then fallsback to the global variable `$NOOP`.
    def noop?
      @noop || $NOOP
    end

    #
    def noop=(boolean)
      @noop = !!boolean
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

    # If `@debug` is `false` or `nil` then fallsback to the global variable `$DEBUG`.
    def debug?
      @debug || $DEBUG
    end

    #
    def debug=(boolean)
      @debug = !!boolean
    end

    # If `@trace` is `false` or `nil` then fallsback to the global variable `$TRACE`.
    def trace?
      @trace || $TRACE
    end

    #
    def trace=(boolean)
      @trace = !!boolean
    end

    # If `@stdin` is nil then fallsback to the global variable `$stdin`.
    # 
    # Returns [IO]
    def stdin
      @stdin || $stdin
    end

    #
    def stdin=(io)
      @stdin = io
    end

    # If `@stdout` is nil then fallsback to the global variable `$stdout`.
    # 
    # Returns [IO]
    def stdout
      @stdout || $stdout
    end

    #
    def stdout=(io)
      @stdout = io
    end

    # If `@stderr` is nil then fallsback to the global variable `$stderr`.
    # 
    # Returns [IO]
    def stderr
      @stderr || $stdrr
    end

    #
    def stderr=(io)
      @stderr = io
    end

    ## Project root directory.
    ##
    ## Returns [Pathname]
    #attr_reader :root
    #
    ##
    #def root=(dir)
    #  @root = Pathname.new(dir)
    #end

    # Glob for finding root of a project.
    #
    # Returns glob string. [String]
    attr :root_pattern

    #
    def root_pattern=(glob)
      @root_pattern = glob
    end

    # Deprecated: A file name policy detrmines how files that
    # have flexiable naming options are to be named exactly.
    # For instance, a file may optionally be capitialized
    # or not. A file name policy of `[:cap]` can then be used
    # to ... this is stupid.
    #
    # Returns [Array<Symbol>]
    attr_reader :file_name_policy

    #
    def file_name_policy=(entry)
      @config[:file_name_policy] ||= (
        Array(entry).map{ |s| s.to_s }
      )
    end

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

  end

end

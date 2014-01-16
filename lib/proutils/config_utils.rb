module ProUtils

  require 'pathname'

  ##
  # ConfigUtils module provides an interface to configuration.
  #
  module ConfigUtils

		#
		def configure(options)
		  @config = Config.new(options)
		end

		#
		def config
		  @config
		end

    def force?   ; config.force?   ; end

    def silent?  ; config.silent?  ; end

    def quiet?   ; config.quiet?   ; end

    def trace?   ; config.trace?   ; end

    def debug?   ; config.debug?   ; end

    def warn?    ; config.warn?    ; end

    def noop?    ; config.noop?    ; end

    def trial?   ; config.trial?   ; end

    def dryrun?  ; config.dryrun?  ; end

  end

  ##
  # The Configuration class provides an data store for very common
  # configuration settings used by other utilities.
  #
  # * force
  # * trial/dryrun
  # * noop
  # * warn
  # * silent/quiet
  # * debug
  # * trace
  #
  # * stdout
  # * stdin
  # * stderr
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

    # A *dryrun* is the same a *verbose* and *noop* togehter.
    def dryrun?
      verbose? && noop?
    end

    alias trial? dryrun?

    #
    def dryrun=(boolean_or_integer)
      self.warn = boolean_or_integer
      self.noop = boolean
    end

    alias trial dryrun

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

    # Project root directory.
    #
    # Returns [Pathname]
    attr_reader :root

    #
    def root=(dir)
      @root = Pathname.new(dir)
    end

    # Glob for finding root of a project.
    #
    # Returns glob string. [String]
    attr :root_pattern

    #
    def root_pattern=(glob)
      @root_pattern = glob
    end

    # Returns [Array<Symbol>]
    attr_reader :file_name_policy

    #
    def file_name_policy=(entry)
      @config[:file_name_policy] ||= (
        Array(entry).map{ |s| s.to_s }
      )
    end

    # Current platform.
    def current_platform
      require 'facets/platform'
      Platform.local.to_s
    end

    # Access RBConfig::CONFIG as an Struct.
    #
    # TODO: Currently this returns an OpenStruct, but it should be
    #       a regular Struct if possible.
    #
    def rbconfig
      @_rbconfig ||= (
        c = ::RbConfig::CONFIG.rekey{ |k| k.to_s.downcase }
        OpenStruct.new(c)
      )
    end

    # The Ruby command, i.e. the path the the Ruby executable.
    def ruby_command
      @_ruby_command ||= (
		    bindir   = rbconfig.bindir
		    rubyname = rbconfig.ruby_install_name
		    File.join(bindir, rubyname).sub(/.*\s.*/m, '"\&"')
      )
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

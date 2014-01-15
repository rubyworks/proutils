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

    def quiet?   ; config.quiet?   ; end

    def trial?   ; config.trial?   ; end

    def trace?   ; config.trace?   ; end

    def debug?   ; config.debug?   ; end

    def verbose? ; config.verbose? ; end

    def noop?    ; config.trial?   ; end

    def dryrun?  ; config.dryrun?  ; end

    def silent?  ; config.silent?  ; end

  end

  ##
  # The Configuration class provides an data store for very common
  # configuration settings used by other utilities.
  #
  # * force
  # * trial
  # * noop
  # * quiet/silent
  # * verbose
  #
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
    def self.attr_boolean(name)
      module_eval %{
        def #{name}?
          @#{name}
        end
        def #{name}=(boolean)
          @#{name} = !!boolean
        end
      }
    end

    #
    def self.alias_boolean(name, target)
      module_eval %{
        alias :#{name}? :#{target}?
        alias :#{name}= :#{target}=
      }
    end

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

    #
    attr_boolean :force

    #
    attr_boolean :quiet

    # Alias for quiet.
    alias_boolean :silent, :quiet

    # Verbose is not the opposite of quiet. Where as quiet literally blocks
    # output, verbose simply means, "provide extra details".
    attr_boolean :verbose

    #
    attr_boolean :trial

    # If `@noop` is nil then fallsback to the global variable `$NOOP`.
    def noop
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

    #
    def dryrun=(boolean)
      self.verbose = boolean
      self.noop    = boolean
    end

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
    def stdin
      @stdin || $stdin
    end

    #
    def stdin=(io)
      @stdin = io
    end

    # If `@stdout` is nil then fallsback to the global variable `$stdout`.
    def stdout
      @stdout || $stdout
    end

    #
    def stdout=(io)
      @stdout = io
    end

    # If `@stderr` is nil then fallsback to the global variable `$stderr`.
    def stderr
      @stderr || $stdrr
    end

    #
    def stderr=(io)
      @stderr = io
    end

    #
    attr_reader :file_name_policy

    # Project root directory.
    #
    attr_reader :root

    #
    def root=(dir)
      @root = Pathname.new(dir)
    end

    #
    def file_name_policy=(entry)
      @config[:file_name_policy] ||= (
        Array(entry).map{ |s| s.to_s }
      )
    end

    # Glob for finding root of a project.
    #
    # Returns glob string. [String]
    attr :root_pattern

    #
    def root_pattern=(glob)
      @root_pattern = glob
    end

    # Current platform.
    def current_platform
      require 'facets/platform'
      Platform.local.to_s
    end

    def rbconfig
      @_rbconfig ||= (
        c = ::RbConfig::CONFIG.rekey{ |k| k.to_s.downcase }
        OpenStruct.new(c)
      )
    end

    # The Ruby command, i.e. the executable.
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

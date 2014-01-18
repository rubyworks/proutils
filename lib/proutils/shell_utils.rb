module ProUtils

  ##
  # ShellUtils provides the whole slew of FileUtils,
  # FileTest and File class methods in a single module
  # and modifies methods according to noop? and verbose?
  # options.
  #
  module ShellUtils

    include ConfigUtils

    # Shell delegator.
    def shell
      @_shell ||= Shell.new(__config__)
    end

    # Shell out to ruby.
    def ruby(*argv)
      shell.out(InfoUtils.ruby_command, *argv)
    end

    # Shortcut to `shell.out` popularized by Rake.
    def sh(*argv)
      shell.out(*argv)
    end

    # Deprecated: Delegate to Ratch::Shell instance.
    #def shell(path=Dir.pwd)
    #  @shell ||= {}
    #  @shell[path] ||= (
    #    mode = {
    #      :noop    => trial?,
    #      :verbose => trace? || (trial? && !quiet?),
    #      :quiet   => quiet?
    #    }
    #    Ratch::Shell.new(path, mode)
    #  )
    #end

    # Make the instance level available at the class level too.
    extend self

  end

  ##
  # Shell class acts as a delegator for shelling out to the command
  # line.
  #
  #     shell = Shell.new
  #     shell.rdoc "-a lib/**/*.rb"
  #
  class Shell

    include ConfigUtils
    include StdioUtils

    #
    def initialize(config=nil)
      @__config__ = config || Config.new
    end

    # Shell out.
    #
    # Returns success of executation. [Boolean]
    def out(*argv)
      cmd = argv.map{ |a| a.to_s }.join(' ')

      trace cmd
      return true if noop?

      success = nil
      if silent?
        silently{ success = system(cmd) }
      else
        success = system(cmd)
      end
      success
    end

    # Shell out to ruby.
    #
    # Returns success of executation. [Boolean]
    def ruby(*argv)
      out(config.ruby_command, *argv)
    end

    #
    def method_missing(c, *a, &b)
      super(c, *a, &b) if b
      out(c, *a)
    end

  end

end

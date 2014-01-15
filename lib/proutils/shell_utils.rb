module ProUtils

  ##
  # ShellUtils provides the whole slew of FileUtils,
  # FileTest and File class methods in a single module
  # and modifies methods according to noop? and verbose?
  # options.
  #
  module ShellUtils

    include ConfigUtils

    #
    def shell
      @_shell || Shell.new(config)
    end

    # Shellout to ruby.
    def ruby(*argv)
      shell.out(config.ruby_command, *argv)
    end

    # Delegate to Ratch::Shell instance.
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
  end

  ##
  #
  class Shell

    include ConfigUtils

    #
    def initialize(config=nil)
      @config = config || Config.new
    end

    # Shell out.
    #
    # Returns success of executation. [Boolean]
    def out(*argv)
      cmd = argv.map{ |a| a.to_s }.join(' ')

      trace cmd
      return true if noop?

      success = nil
      if quiet?
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

    # Make the instance level available at the class level too.
    extend self

  end

end

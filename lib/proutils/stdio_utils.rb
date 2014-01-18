module ProUtils

  ##
  # Standard IO utility methods.
  #
  module StdioUtils

    include ConfigUtils

    #
    def stdin
      $stdin
    end

    #
    def stdout
      # return dev/null if silent?
      $stdout
    end

    #
    def stderr
      $stderr
    end

    #
    def print(str=nil)
      return if silent?
      stdout.print(str.to_s)
    end

    #
    def puts(str=nil)
      return if silent?
      stdout.puts(str.to_s)
    end

    #
    def warn(message)
      #return if silent?
      stderr.puts "WARNING ".ansi(:yellow) + message.to_s
    end

    #
    def status(message)
      return if silent?
      stdout.puts "#{message}".ansi(:bold)
    end

    # Same as status.
    #
    # @deprecated
    #   Doubley redundant with #status and #puts.
    alias report status

    # Internal trace report. Only output if in trace mode.
    def trace(message)
      #return if silent?
      if trace?
        stderr.print "(TRIAL RUN) " if trial?
        stderr.puts message
      end
    end

    # Convenient method to get simple console reply.
    def ask(question)
      stdout.print "#{question} "
      stdout.flush
      input = stdin.gets #until inp = stdin.gets ; sleep 1 ; end
      input.strip
    end

    # TODO: Until we have better support for getting input across
    # platforms, we are using #ask for passwords too.
    def password(prompt=nil)
      prompt ||= "Enter Password: "
      ask(prompt)
    end

    # Make the instance level available at the class level too.
    extend self

  end

end

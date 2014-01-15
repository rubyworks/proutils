module FileTest

  module_function

  # Return a cached list of the PATH environment variable.
  # This is a support method used by #bin?
  #
  # Returns [Array]

  def command_paths
    @command_paths ||= (
      list = []
      if path = ENV['PATH']
        list.concat path.split(/[:;]/)
      end
      list
    )
  end

  # Is a file a bin/ executable?
  #
  # TODO: Make more robust. Probably needs to be fixed for Windows.
  #       What's the right way to do this?
  #
  # Returns the file name or false. [String,False]

  def bin?(fname)
    is_bin = command_paths.any? do |dir|
      file = File.join(dir, fname)
      FileTest.exist?(file)
    end
    #is_bin ? file : false
    is_bin ? fname : false
  end

end


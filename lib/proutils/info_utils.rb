module ProUtils

  ##
  # Methods for accessing system information.
  #
  module InfoUtils

    # Access RBConfig::CONFIG as an Struct.
    #
    # TODO: Currently this returns an OpenStruct, but should be
    #       a regular Struct instead?
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
		    bindir   = ::RbConfig::CONFIG['bindir']
		    rubyname = ::RbConfig::CONFIG['ruby_install_name']
		    File.join(bindir, rubyname).sub(/.*\s.*/m, '"\&"')
      )
    end

    # Current platform.
    def current_platform
      require 'facets/platform'
      Platform.local.to_s
    end

    # Make the instance level available at the class level too.
    extend self

  end

end

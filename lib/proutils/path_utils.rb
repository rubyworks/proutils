module ProUtils

  ##
  # Project path utilities.
  #
  module PathUtils

    include ConfigUtils

    #
    def path(pathname)
      Path.new(pathname)
    end

    # Alias for #path.
    alias :file :path
 
    # Project root directory. If not already set, this method will try
    # to find the project root using SCM markers. If not found, it
    # assumes the current working directory must be the project root.
    #
    # Returns [Pathname]
    def root
      config.root ||= (
        find_root || Path.new(Dir.pwd, config)
      )
    end

    # Find project root directory looking for SCM markers.
    #
    # Returns [Pathname]
    def find_root
      path = nil
      home = File.expand_path('~')

      while dir != home && dir != '/'
        if Dir[config.root_pattern].first
          path = dir
          break
        end
        dir = File.dirname(dir)
      end

      path ? Path.new(path, config) || nil
    end

    # Apply a naming policy to a file name and extension.
    #
    # Returns the file name. [String]
    def apply_file_name_policy(name, ext)
      config.file_name_policy.each do |policy|
        case policy.to_s
        when /^low/, /^down/
          name = name.downcase
        when /^up/
          name = name.upcase
        when /^cap/
          name = name.capitalize
        when /^ext/
          name = name + ".#{ext}"
        end
      end
      name
    end

    # Make the instance level available at the class level too.
    extend self

  end

  ##
  # All the things you can do with a single path.
  #
  class Path < ::Pathname

    #
    def initialize(path, config=nil)
      super(path)
      @config = config || ProUtils.configuration
    end

    #
    attr :config

    def identical?(other)
      FileTest.identical?(path, other)
    end

    # Write to file.
    def write(*args)
      stderr.puts "write #{path}" if config.trace?
      super(*args) unless config.noop?
    end

    # Append to file.
    def append(text)
      stderr.puts "append #{path}" if config.trace?
      File.open(path, 'a'){ |f| f << text } unless config.noop?
    end

  end

end

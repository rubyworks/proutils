module ProUtils

  ##
  # Project path utilities.
  #
  module PathUtils

    include ConfigUtils

    #
    def path(pathname)
      Path.new(pathname, __config__)
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
        find_root || Path.new(Dir.pwd, __config__)
      )
    end

    # Find project root directory looking for SCM markers.
    #
    # Returns [Pathname]
    def find_root
      path = nil
      home = File.expand_path('~')

      while dir != home && dir != '/'
        if Dir[__config__.root_pattern].first
          path = dir
          break
        end
        dir = File.dirname(dir)
      end

      path ? Path.new(path, config) : nil
    end

    # Apply a naming policy to a file name and extension.
    #
    # Returns the file name. [String]
    def apply_file_name_policy(name, ext)
      __config__.file_name_policy.each do |policy|
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
  # The Path class provides all the things you can do with a single path.
  # It is essentially the same as Ruby Pathname class, except if supports
  # the `trace` and `noop` options.
  #
  # TODO: Add options to #open and #sysopen based on writable permission.
  #
  class Path < ::Pathname

    #include ConfigUtils
    #include StdioUtils

    #
    def initialize(path, options={})
      @trace = options[:trace] || options[:dryrun]
      @noop  = options[:noop]  || options[:dryrun]

      super(path)
    end

    def trace?
      @trace || $TRACE
    end

    def noop?
      @noop || $NOOP
    end

    def trial?
      trace? && noop?
    end

    alias dryrun? trial? 

    # Pathname methods that can modify the file system.
    DRYRUN_METHODS = [
      :chmod, :lchmod, :chown, :lchown, :make_link, :rename,
      :make_symlink, :truncate, :utime, :mkdir, :mkpath, 
      :rmdir, :rmtree, :unlink, :delete
    ]

    DRYRUN_METHODS.each do |methname|
      module_eval %{
        def #{methname}(*args)
          if trace?
            $stderr.print "(TRIAL RUN) " if trial?
            $stderr.puts "path #{methname} \#{self} \#{args.join(' ')}"
          end
          super(*args) unless noop?
        end
      }
    end

    # Write to file.
    def write(*args)
      $stderr.puts "write #{path}" if trace?
      super(*args) unless noop?
    end

    # Append to file.
    def append(text)
      $stderr.puts "path append #{path}" if trace?
      File.open(path, 'a'){ |f| f << text } unless noop?
    end

    #
    def identical?(other)
      FileTest.identical?(path, other)
    end

  end

end

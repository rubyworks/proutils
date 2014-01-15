module ProUtils

  module FileUtils

    include ConfigUtils

    # -- Dir Methods ----------------------------------------------------------

    #
    def glob(*args)
      Dir.glob(*args)
    end

    # TODO: Ultimately merge #glob and #multiglob.
    def multiglob(*args, &blk)
      Dir.multiglob(*args, &blk)
    end

    #
    def multiglob_r(*args, &blk)
      Dir.multiglob_r(*args, &blk)
    end

    # -- File Methods ---------------------------------------------------------

    # Read file.
    def read(path)
      File.read(path)
    end

    # Write file.
    def write(path, text)
      stderr.puts "write #{path}" if trace?
      File.open(path, 'w'){ |f| f << text } unless noop?
    end

    # Append to file.
    def append(path, text)
      stderr.puts "append #{path}" if trace?
      File.open(path, 'a'){ |f| f << text } unless noop?
    end

    #
    def atime(*args) ; File.ctime(*args) ; end
    def ctime(*args) ; File.ctime(*args) ; end
    def mtime(*args) ; File.mtime(*args) ; end

    def utime(*args)
      File.utime(*args) unless noop?
    end

    # -- FileTest Methods -----------------------------------------------------

    #
    def size(path)             ; FileTest.size(path)             ; end
    def size?(path)            ; FileTest.size?(path)            ; end
    def directory?(path)       ; FileTest.directory?(path)       ; end
    def symlink?(path)         ; FileTest.symlink?(path)         ; end
    def readable?(path)        ; FileTest.readable?(path)        ; end
    def chardev?(path)         ; FileTest.chardev?(path)         ; end
    def exist?(path)           ; FileTest.exist?(path)           ; end
    def exists?(path)          ; FileTest.exists?(path)          ; end
    def zero?(path)            ; FileTest.zero?(path)            ; end
    def pipe?(path)            ; FileTest.pipe?(path)            ; end
    def file?(path)            ; FileTest.file?(path)            ; end
    def sticky?(path)          ; FileTest.sticky?(path)          ; end
    def blockdev?(path)        ; FileTest.blockdev?(path)        ; end
    def grpowned?(path)        ; FileTest.grpowned?(path)        ; end
    def setgid?(path)          ; FileTest.setgid?(path)          ; end
    def setuid?(path)          ; FileTest.setuid?(path)          ; end
    def socket?(path)          ; FileTest.socket?(path)          ; end
    def owned?(path)           ; FileTest.owned?(path)           ; end
    def writable?(path)        ; FileTest.writable?(path)        ; end
    def executable?(path)      ; FileTest.executable?(path)      ; end

    def safe?(path)            ; FileTest.safe?(path)            ; end

    def relative?(path)        ; FileTest.relative?(path)        ; end
    def absolute?(path)        ; FileTest.absolute?(path)        ; end

    def writable_real?(path)   ; FileTest.writable_real?(path)   ; end
    def executable_real?(path) ; FileTest.executable_real?(path) ; end
    def readable_real?(path)   ; FileTest.readable_real?(path)   ; end

    def identical?(path, other)
      FileTest.identical?(path, other)
    end

    # -- FileUtils Methods ----------------------------------------------------

    # Returns Ruby's FileUtils module based on mode.
    def fileutils
      if dryrun?
        ::FileUtils::DryRun
      elsif noop? or trial?
        ::FileUtils::Noop
      elsif trace?
        ::FileUtils::Verbose
      else
        ::FileUtils
      end
    end

    # Fallback to filutils.
    #
    # TODO: delegate this better?
    def method_missing(s, *a, &b)
      if fileutils.respond_to?(s)
        fileutils.send(s, *a, &b)
      else
        super(s, *a, &b)
      end
    end

    # Make the instance level available at the class level too.
    extend self

  end

end

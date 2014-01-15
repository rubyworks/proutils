# ProUtils

[Website](http://rubyworks.github.io/proutils) /
[Report Issue](http://github.com/rubyworks/proutils/issues) /
[Development](http://github.com/rubyworks/proutils)

[![Build Status](http://travis-ci.org/rubyworks/proutils.png)](http://travis-ci.org/rubyworks/proutils) 
[![Gem Version](https://badge.fury.io/rb/proutils.png)](http://badge.fury.io/rb/proutils) &nbsp; &nbsp;
[![Flattr Me](http://api.flattr.com/button/flattr-badge-large.png)](http://flattr.com/thing/324911/Rubyworks-Ruby-Development-Fund)


## About

ProUtils is a set of utility methods design primarily for project
development.


## Usage

ProUtils provides it;s utility methods in a handful of independent
modules.

* `ConfigUtils` - Used by all modules to hande configuration of utility methods.
* `EmailUtils`  - Provides utility methods to make it easy to send emails.
* `PathUtils`   - Convenience methods for working with Pathname instances.
* `ShellUtils`  - Utility methods for shelling out to the command line.
* `StdioUtils`  - Utility methods for read and writing to standard IO.
* `FileUtils`   - An expanded version of Ruby's FileUtils module.

There will likey be a few more modules added in the future and some may
be reformulate a bit as this is yet at an early stage of developement.

In additon a dozen or so core extensions are cherry picked from Facets to
faciliate the utility methods.


## Tips

If you don't want to fill up a class with a ton of FileUtils methods,
but still want relatively easy access to those methods then define
a file system delegator.

    def fs
      ProUtils::FileUtils
    end

Then you can just call against `fs` as needed, e.g.

    fs.write("hello.txt", "Hello World!")


## Copyrights

Copyright (c) 2014 Rubyworks



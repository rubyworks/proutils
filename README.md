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

ProUtils provides its utility methods in a handful of independent modules.

* `ConfigUtils` - Used by all modules to handle configuration of utility methods.
* `EmailUtils`  - Provides utility methods to make it easy to send emails.
* `InfoUtils`   - Provides utility methods for accessing system information.
* `PathUtils`   - Convenience methods for working with file system paths.
* `ShellUtils`  - Utility methods for shelling out to the command line.
* `StdioUtils`  - Methods for read and writing to standard IO.
* `FileUtils`   - An expanded version of Ruby's FileUtils module.

There will likely be a few more modules added in the future and some could
be reformulated a bit, as this project is still in an fairly early stage
of development.

Also included are a few supporting classes that can be used independently
as well.

* `Path`  - An improved subclass of `Pathname` that takes configuration into account.
* `Shell` - A delegator for shelling out to the command line via method calls.

Lastly, there are two dozen or so core extensions cherry picked from Ruby Facets
to facilitate the utility methods.


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



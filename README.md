# Stringer

Stringer takes the sting out of `genstrings`, by making it not overwriting your `Localizations.strings` file each time you run `genstrings`.

It wraps `genstrings` and adds some basic merging capabilities (add and remove keys).

## Why?

When you run `genstrings` it goes through each of your specified `.m` files, looks for `NSLocalizedString`, parses out the key and comment, adds it to a Localizable.strings file.

Downside to this utility: it completely overwrites any changes you make to the `Localizations.strings` file (or if you give it the `-a` flag, it will at least append).

That's where `stringer` comes in, makes `genstrings` suck less.

## Installation

Stringer requires ruby > 1.9.

The easiest way to use `stringer` at the moment is to add a `Gemfile` to the root of your project and add `stringer` to it, like so:

    gem 'stringer'

Then execute:

    $ bundle

Now you can create a Rakefile, and add these lines:

    require "stringer"

    desc "Run genstrings to update the Localizable.strings files"
    task :localize do
      %w(en fr nl).each do |locale|
        Stringer.run(locale)
      end
    end

Now you can update your `Localizations.strings` file by running:

    rake localize

Which will output something like this:

    Generating en.lproj
     - Added 3 keys (die.tijd;duvels;piet...)
     - Removed 1 key (dotter...)

## The future

`0.1.0`: Iron out bugs and missing options.

`0.1.x`: Add support for ruby 1.8.7 and up.

`0.2.0`: Add a bin, so the Rake-file shenanigans are no longer necessary.

`0.3.0`: Ditch the dependency `genstrings` and fetch strings ourselves.

...

`1.0.0`: Installed by default on OSX TomCat

## The past

First "version" of stringer was a ruby script by [@inferis](http://twitter.com/inferis), it grew out of client projects at [10to1](http://10to1.be) and turned into a gem on one saturday night.

## Contributing

Fork it! Improve it! Test it! Rewrite it! (technology)

[![Build Status](https://secure.travis-ci.org/pjaspers/stringer.png?branch=master)](http://travis-ci.org/pjaspers/stringer)

require "minitest/autorun"
require "mocha"

begin
  # [turn](http://rubygems.org/gems/turn)
  require 'turn/autorun'
rescue LoadError
end

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'stringer'

def locale_file_path
    File.join(File.dirname(__FILE__), "Localizable.strings")
end

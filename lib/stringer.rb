require "stringer/version"
require "stringer/strings_file"
require "stringer/processor"

module Stringer

  def run(locale, options = {})
    Stringer::Processor.new(locale, options).run
  end

end

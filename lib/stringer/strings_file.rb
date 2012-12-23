module Stringer
  class StringsFile
    attr_accessor :lines

    def initialize(lines, path = nil)
      @lines = lines
      @path = path
    end

    # Sets up a stringsfile by reading the lines in the file at the
    # passed in path. Will raise an error if file not found.
    # TODO: Pass a more sensible error.
    #
    # file_path - path to Localizations.strings file
    #
    # Returns a `StringsFile` instance
    def self.with_file(file_path)
      check_for_file(file_path)
      lines = fetch_lines_at(file_path)
      new(lines, file_path)
    end

    def self.check_for_file(path)
      raise "No Localisations found at #{path}" unless File.exist?(path)
    end

    def self.fetch_lines_at(path)
      IO.readlines(path, mode: "rb:UTF-16LE").collect do |l|
        l.encode("UTF-8").gsub("\uFEFF", "")
      end
    end

    def comment_lines
      @lines.select{|l| l =~ /^\/\*/ }
    end

    def translation_lines
      @lines.select{|l| l =~ /^"/}
    end

    def comments
      @comments ||= comment_lines.collect do |line|
        line.gsub("/*", "").gsub("*/", "").strip
      end
    end

    # Not all NSLocalizedString keys are created equally, in fact, being able to
    # create keys in a loop a Good Thing. `Stringer` will treat all keys starting
    # with a _ as dynamic keys, and will never try to remove them.
    #
    # Returns a bool
    def dynamically_generated_key?(key)
      key.start_with? "_"
    end

    def translation_hash
      return @translation_hash if @translation_hash

      @translation_hash = translation_lines.inject({}) do |r,line|
        r[key_from_line(line)] = value_from_line(line)
        r
      end
    end

    def key_from_line(line)
      line.split("=").first.gsub("\"", "").strip
    end

    def value_from_line(line)
      line.split("=").last.strip.gsub(";", "").gsub("\"", "")
    end

    def apply(other_string_file)
      removed_keys = translation_hash.keys - other_string_file.translation_hash.keys
      removed_keys = removed_keys.reject {|k| dynamically_generated_key?(k)}
      added_keys = other_string_file.translation_hash.keys - translation_hash.keys
      @translation_hash = other_string_file.translation_hash.merge(translation_hash)
      removed_keys.each {|k| @translation_hash.delete(k)}
      [added_keys, removed_keys]
    end

    def write!
      return unless @path
      File.open(@path, "wb:UTF-16LE") do |file|
        file.write("\uFEFF")
        file.write("/* Generated */\n")
        translation_hash.each do |key, value|
          file.puts "\"#{key}\" = \"#{value}\";"
        end
      end
    end
  end
end

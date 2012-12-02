module Stringer
  class StringsFile
    attr_accessor :lines

    def initialize(path)
      check_for_file(path)
      @path = path
      @lines = fetch_lines_at(path)
    end

    def check_for_file(path)
      raise "No Localisations found at #{path}" unless File.exist?(path)
    end

    def fetch_lines_at(path)
      IO.readlines(path, :mode => "rb:UTF-16LE").collect do |l|
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
      added_keys = other_string_file.translation_hash.keys - translation_hash.keys
      @translation_hash = other_string_file.translation_hash.merge(translation_hash)
      removed_keys.each {|k| @translation_hash.delete(k)}
      [added_keys, removed_keys]
    end

    def write!
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

module Stringer
  class Processor

    # The Processor will be doing the genstringing part of the
    # operation.
    #
    # Possible options:
    #
    #    - file_folder  : Folder where `genstrings` should look for
    #                     .m files. It searches this recursively.
    #    - genstrings   : Location of the genstrings command
    #    - lproj_parent : Path to folder containing the `<locale>.lproj`
    #
    def initialize(locale, options = {})
      options       = default_options.merge(options)
      @locale       = locale
      @files_folder = options[:files_folder]
      @genstrings   = options[:genstrings]
      @lproj_parent = options[:lproj_parent]
    end

    # Some sensible defaults in a hash
    def default_options
      {
        :lproj_parent => dir_path_for_dir_with_same_name_as_parent_dir,
        :files_folder => dir_path_for_dir_with_same_name_as_parent_dir,
        :genstrings => "/usr/bin/genstrings"
      }
    end

    # If standard Xcode template is used, this is the dir where most
    # files will be. For a project created with name "Something"
    #
    #      Something:
    #        Something:
    #          en.lproj/
    #          *.m
    #
    # Returns the path
    def dir_path_for_dir_with_same_name_as_parent_dir
      current_dir_path = Dir.pwd
      current_dir_name = File.basename(current_dir_path)
      File.join(current_dir_path, current_dir_name)
    end

    def genstrings_command
      "#{@genstrings} -q -o #{lproj_folder} #{files.join(" ")}"
    end

    # Returns an array of all files needed to be processed.
    def files
      `find #{@files_folder} -name \*.m`.split("\n")
    end

    def run
      log("Generating #{@locale}.lproj")
      original_file = StringsFile.new(strings_file_path)
      if system(genstrings_command)
        new_file = StringsFile.new(strings_file_path)
        added_keys, removed_keys = original_file.apply(new_file)
        show_changes(added_keys, "Added")
        show_changes(removed_keys, "Removed")
      end
      original_file.write!
    end

    def lproj_folder
      File.join(@lproj_parent, "#{@locale}.lproj")
    end

    def strings_file_path
      "#{lproj_folder}/Localizable.strings"
    end

    def log(message)
      puts message
    end

    def show_changes(keys, string)
      number = keys.count
      if number == 1
        string = " - #{string} #{number} key"
      else
        string = " - #{string} #{number} keys"
      end
      string << " (#{keys.join(";")[0..50]}...)" unless number == 0
      log string
    end
  end
end

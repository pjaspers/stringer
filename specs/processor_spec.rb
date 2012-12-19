require "helper"

describe Stringer::Processor do

  describe "creating the genstrings command" do

    it "should use sensible defaults if no options given" do
      Stringer::Processor.any_instance.stubs(:dir_path_for_dir_with_same_name_as_parent_dir).returns("path")
      processor = Stringer::Processor.new("nl")
      processor.stubs(:files).returns(["file_a"])
      processor.genstrings_command.must_equal("/usr/bin/genstrings -q -o path/nl.lproj file_a")
    end

    it "should use the supplied options" do
      processor = Stringer::Processor.new("nl", :files_folder => "files", :lproj_parent => "lproj_parent", :genstrings => "/opt/bin/genstrings")
      processor.stubs(:files).returns(["file_a"])
      processor.genstrings_command.must_equal("/opt/bin/genstrings -q -o lproj_parent/nl.lproj file_a")
    end

  end

  describe "setting the correct directories" do
    it "should be started from the current directory" do
      Dir.stubs(:pwd).returns('/Users/dev/Project1')

      processor = Stringer::Processor.new("nl")
      processor.dir_path_for_dir_with_same_name_as_parent_dir.must_equal "/Users/dev/Project1/Project1"
    end
  end
end

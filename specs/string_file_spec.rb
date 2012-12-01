require "helper"

describe Stringer::StringsFile do

  it "should have loaded the lines from the file" do
    file = Stringer::StringsFile.new(locale_file_path)
    file.lines.wont_be_empty
  end

  it "should raise if no file found" do
    -> {Stringer::StringsFile.new("404")}.must_raise RuntimeError
  end

  describe "transforming file to strings" do
    before do
      lines = ["/* A comment */",
               "\"a.key\" = \"Translated Key\";\n"]
      Stringer::StringsFile.any_instance.expects(:fetch_lines_at).with("path").returns(lines)
      Stringer::StringsFile.any_instance.stubs(:check_for_file).with("path").returns(nil)
      @file = Stringer::StringsFile.new("path")
    end

    it "should have transformed the comments" do
      @file.comments.first.must_equal("A comment")
    end

    it "should have extracted the keys" do
      @file.translation_hash["a.key"].wont_be_nil
    end

    it "should have extracted the value" do
      @file.translation_hash["a.key"].must_equal "Translated Key"
    end
  end
end

require "helper"

describe Stringer::StringsFile do

  it "should have loaded the lines from the file" do
    file = Stringer::StringsFile.with_file(locale_file_path)
    file.lines.wont_be_empty
  end

  it "should raise if no file found" do
    -> {Stringer::StringsFile.with_file("404")}.must_raise RuntimeError
  end

  describe "transforming file to strings" do
    before do
      lines = ["/* A comment */",
               "\"a.key\" = \"Translated Key\";\n"]
      @file = Stringer::StringsFile.new(lines, "path")
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

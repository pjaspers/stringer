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

  describe "applying a new file to the old one" do
    before do
      old_file = <<FILE
/* A comment */
"a.key" = "Translated Key";
"_.another.key = "Dynamic key";
FILE

      new_file =  <<FILE
/* A comment */
"a.key" = "Changed Translated Key";
"b.key" = "New B key";
FILE
      @old = Stringer::StringsFile.new(old_file.split("\n"))
      @new = Stringer::StringsFile.new(new_file.split("\n"))
      @old.apply(@new)
    end

    it "should have added the b.key" do
      assert_includes @old.translation_hash.keys, "b.key"
    end

    it "should have not have changed the contents of the a.key" do
      assert_equal "Translated Key", @old.translation_hash["a.key"]
    end

    it "should not remove dynamic keys" do
      assert_includes @old.translation_hash.keys, "_.another.key"
    end
  end
end

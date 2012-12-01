require "helper"

describe Stringer do

  it "should tell the processor to run :)" do
    proc = mock("Stringer::Processor")
    proc.expects(:run)
    Stringer::Processor.expects(:new).with("en", {}).returns(proc)
    Stringer.run("en")
  end
end

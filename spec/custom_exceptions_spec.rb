require File.dirname(__FILE__) + '/spec_helper.rb'

describe "CustomExceptions" do
  context "Module" do
    it "loads an exception definition file" do
      expect(CustomExceptions.load("./spec/test_config.yml")).to eq ({"default_exception" => {"code"=>10001, "message"=>"This is a default exception", "metadata"=>{"key1"=>"value1", "key2"=>"value2"}, "status"=>501}, "argument_exception" => {"code"=>10002, "message"=>"This is an argument exception", "metadata"=>{"key1"=>"value1", "key2"=>"value2", "key3"=>"value3"}, "status"=>502}})
    end
    
    it "defines the various exception classes in exception definition file" do
      CustomExceptions.load("./spec/test_config.yml")
      expect(CustomExceptions::DefaultException).to eq (CustomExceptions::DefaultException)
      expect(CustomExceptions::ArgumentException).to eq (CustomExceptions::ArgumentException)
    end
    
    it "raises error on accessing undefined exception" do
      expect { CustomExceptions::UndefinedException }.to raise_error(NameError)
    end
    
    it "returns values defined in exception definition file" do
      CustomExceptions.load("./spec/test_config.yml")
      
      expect(CustomExceptions::DefaultException.new.code).to eq 10001
      expect(CustomExceptions::DefaultException.new.message).to eq "This is a default exception"
      expect(CustomExceptions::DefaultException.new.metadata).to eq ({"key1"=>"value1", "key2"=>"value2"})
      expect(CustomExceptions::DefaultException.new.status).to eq 501
      
      expect(CustomExceptions::ArgumentException.new.code).to eq 10002
      expect(CustomExceptions::ArgumentException.new.message).to eq "This is an argument exception"
      expect(CustomExceptions::ArgumentException.new.metadata).to eq ({"key1"=>"value1", "key2"=>"value2", "key3"=>"value3"})
      expect(CustomExceptions::ArgumentException.new.status).to eq 502
    end
    
    it "allows defining exceptions during runtime" do
      expect(CustomExceptions.exception(:RUNTIME_EXCEPTION)).to eq(CustomExceptions::RuntimeException)
      expect(CustomExceptions.exception(:RUNTIME_EXCEPTION).new(code: 10003).code).to eq 10003
      expect(CustomExceptions.exception(:RUNTIME_EXCEPTION).new(code: 10003, message: "This is a runtime exception").message).to eq "This is a runtime exception"
      expect(CustomExceptions.exception(:RUNTIME_EXCEPTION).new(code: 10003, message: "This is a runtime exception", status: 500).status).to eq 500
      expect(CustomExceptions.exception(:RUNTIME_EXCEPTION).new(code: 10003, message: "This is a runtime exception", status: 500, metadata: {"key" => "value"}).metadata).to eq ({"key" => "value"})
    end
  end
  
  context "using Base" do
    it "allows raising and catching of exceptions" do
      CustomExceptions.load("./spec/test_config.yml")
      expect { raise CustomExceptions::DefaultException }.to raise_error(CustomExceptions::DefaultException)
      expect { raise CustomExceptions::DefaultException }.to raise_error(CustomExceptions::Base)
      expect { raise CustomExceptions::DefaultException }.to raise_error{ |e| expect(e.code).to eq 10001 }
      expect { raise CustomExceptions.exception(:RUNTIME_EXCEPTION).new(code: 10003)}.to raise_error{ |e| expect(e.code).to eq 10003 }
    end
  end
end

require_relative 'custom_exceptions/base'
require_relative 'custom_exceptions/string'
require 'yaml'

module CustomExceptions
  
  VERSION = "0.0.1"
  
  class << self
    
    def load(file)
     @config = YAML.load_file(file)
     define_exceptions
    end
    
    def error_constants
      @config.each_with_object({}) do |const, hash|
        hash[const.first] = const.last
      end
    end
    
    def define_exceptions
      error_constants.each do |name, error_body|
        klass = Class.new(CustomExceptions::Base)
        klass.send(:define_method, :initialize) do |options={}|
          @metadata = options[:metadata]
          @code = options[:code]
          @message = options[:message]
          @status = options[:status] || 500
        end
        klass.send(:define_method, :metadata) { @metadata }
        klass.send(:define_method, :code) { @code || error_body["code"]}
        klass.send(:define_method, :message) { @message || error_body["message"] }
        klass.send(:define_method, :status) { @status || error_body["status"]}
        CustomExceptions.const_set(name.classify, klass)
      end
    end
    
    def exception(class_name)
      if const_defined?(class_name)
        CustomExceptions.const_get(class_name)
      else
        runtime_exception(class_name)
      end
    end
    
    def runtime_exception(name)
      klass = Class.new(CustomExceptions::Base)
      klass.send(:define_method, :initialize) do |options={}|
        @metadata = options[:metadata]
        @code = options[:code]
        @message = options[:message] || name.to_s.split("_").join(' ').downcase.capitalize
        @status = options[:status] || 500
      end
      klass.send(:define_method, :metadata) { @metadata }
      klass.send(:define_method, :code) { @code }
      klass.send(:define_method, :message) { @message }
      klass.send(:define_method, :status) { @status }
      CustomExceptions.send(:remove_const, name.to_s.classify) if CustomExceptions.const_defined?(name.to_s.classify)
      CustomExceptions.const_set(name.to_s.classify, klass)
    end
    
  end

end

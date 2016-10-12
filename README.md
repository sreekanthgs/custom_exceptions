# README

CustomExceptions allows generation of custom exception classes from yaml config files or at runtime to be used in Ruby or RubyonRails.

## Usage
Installing
```ruby
gem install custom_exceptions       # For Ruby
gem 'custom_exceptions'             # For Rails/Gemfile
```
Load config file
```ruby
require 'custom_exceptions'
CustomExceptions.load(file_path)
```
File Structure
```yaml
default_exception:
  code: 10001
  message: This is a default exception
  metadata:
    key1: value1
    key2: value2
  status: 501
  
argument_exception:
  code: 10002
  message: This is an argument exception
  metadata:
    key1: value1
    key2: value2
    key3: value3
  status: 502
```
Exceptions Usage
```ruby
begin
  raise CustomExceptions::DefaultException
rescue CustomExceptions::DefaultException => e
  error_code = e.code           #10001
end
```
You can also modify predefined exceptions values *as in file* in runtime
```ruby
begin
  raise CustomExceptions::DefaultException.new(code: 50001)
rescue CustomExceptions::DefaultException => e
  error_code = e.code           #50001
end
```
You can rescue the exceptions with their base class
```ruby
begin
  raise CustomExceptions::DefaultException
rescue CustomExceptions::Base => e
  exception_class = e.class     #CustomExceptions::DefaultException
  error_code = e.code           #50001
end
```
You can define runtime exceptions and still catch them with base class or the exceptions class
```ruby
begin
  raise CustomExceptions.exception(:RUNTIME_EXCEPTION).new(code: 50002)
rescue CustomExceptions::Base => e
  exception_class = e.class     #CustomExceptions::RuntimeException
  error_code = e.code           #50002
end
```
## Usage in Rails
All usage notes as above. You may rescue from exceptions and give proper response to users, for example in the case of an API project:
```ruby
# in app/controllers/application_controller.rb
rescue_from CustomExceptions::Base do |e|
  render json: {result: nil, error: {code: e.code, message: e.message, metadata: e.metadata}}, status: e.status || 500
end
```
## Credits
* Stac (https://wearestac.com/blog/raising-and-rescuing-custom-errors-in-rails)

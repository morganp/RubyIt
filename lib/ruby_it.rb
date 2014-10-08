module RubyIt
  VERSION = "0.5.0"
end

#Ruby 1.9.2 did not work with the relative links
begin
  require_relative "ruby_it/document"
  require_relative "ruby_it/ruby_it_options"
rescue
  require "ruby_it/document"
  require "ruby_it/ruby_it_options"
end

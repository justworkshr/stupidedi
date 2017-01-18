# frozen_string_literal: true
require "bigdecimal"
require "time"
require "date"
require "set"

begin
  require "term/ansicolor" if $stdout.tty?
rescue LoadError
  warn "terminal color disabled. gem install term-ansicolor to enable"
end

$:.unshift(File.expand_path("..", __FILE__))

require "ruby/symbol"
require "ruby/object"
require "ruby/module"
require "ruby/array"
require "ruby/hash"
require "ruby/string"
require "ruby/blank"
require "ruby/to_d"
require "ruby/to_date"
require "ruby/to_time"
require "ruby/try"
require "ruby/instance_exec"

module Stupidedi
  autoload :Builder,      "stupidedi/builder"
  autoload :Config,       "stupidedi/config"
  autoload :Contrib,      "stupidedi/contrib"
  autoload :Color,        "stupidedi/color"
  autoload :Versions,     "stupidedi/versions"
  autoload :Editor,       "stupidedi/editor"
  autoload :Exceptions,   "stupidedi/exceptions"
  autoload :Guides,       "stupidedi/guides"
  autoload :Reader,       "stupidedi/reader"
  autoload :Schema,       "stupidedi/schema"
  autoload :Values,       "stupidedi/values"
  autoload :Writer,       "stupidedi/writer"
  autoload :Zipper,       "stupidedi/zipper"

  autoload :Sets,             "stupidedi/sets"
  autoload :Either,           "stupidedi/either"
  autoload :Inspect,          "stupidedi/inspect"
  autoload :TailCall,         "stupidedi/tail_call"
  autoload :BlankSlate,       "stupidedi/blank_slate"
  autoload :ThreadLocalVar,   "stupidedi/thread_local"
  autoload :ThreadLocalHash,  "stupidedi/thread_local"

  # We can use a much faster implementation provided by the "called_from"
  # gem, but this only compiles against Ruby 1.8. Use this implementation
  # when its available, but fall back to the slow Kernel.caller method if
  # we have to
  if RUBY_VERSION < "1.9"
    require "called_from"
    def self.caller(depth = 2)
      ::Kernel.called_from(depth)
    end
  else
    def self.caller(depth = 2)
      if k = ::Kernel.caller.at(depth - 1)
        k.split(":")
      end
    end
  end
end

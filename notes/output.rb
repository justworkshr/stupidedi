#!/usr/bin/env ruby
require "pathname"
$:.unshift(File.expand_path("../../lib", Pathname.new(__FILE__).realpath))

require "stupidedi"
require "pp"

# This will be auto-enabled when $stdout.tty?, but -C forces color output
require "term/ansicolor" if ARGV.delete("-C")

config = Stupidedi::Config.hipaa
parser = Stupidedi::Builder::StateMachine.build(config)
start  = Time.now

ARGV.each do |path|
  File.open(path) do |io|
    parser, result = parser.read(Stupidedi::Reader.build(io))
    pp result
  end
end

stop = Time.now

parser.zipper.map{|z| pp z.root.node }.
  explain { puts "Non-deterministic state" }

#begin
#  count  = 0
#  cursor = parser.first
#
#  while cursor.defined?
#    count += 1
#    cursor = cursor.flatmap{|c| c.next }
#  end
#
#  puts "#{count} segments"
#end
#
#begin
#  a = parser.first
#  b = parser.last
#
#  a.flatmap{|a| b.flatmap{|b| a.distance(b) }}.
#    tap{|d| puts "#{d + 1} segments" }
#end

separators = Stupidedi::Reader::Separators.build \
  :element => "*",
  :segment => "~\n"

cursor = parser.first
while cursor.defined?
  cursor = cursor.flatmap do |isa|
    either =
      if isa.deterministic?
        isa.zipper
      else
        Stupidedi::Either.success(isa.active.head.node.zipper)
      end.map(&:up)

    either.tap do |z|
      $stdout.puts("*" * 80)
      writer = Stupidedi::Writer::Default.new(z, separators)
      writer.write($stdout)
      $stdout.puts
    end

    isa.find(:ISA)
  end
end

puts "%0.3f seconds" % (stop - start)

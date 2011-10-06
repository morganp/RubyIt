require 'spec_helper'

describe RubyIt do
  before(:all) do
    @prefix = File.dirname( __FILE__ )

    puts @prefix
  end
  describe RubyIt, "Command Line Interface" do
    it "Generates Files to correct output folder" do 
      source                  = "#{@prefix}/../examples/hello_erb.rtxt"
      generated               = "#{@prefix}/../generated/hello_erb.txt"
      source_expected_text    = "\n<% 3.times do -%>\n<%= 'hello' %>\n<% end -%>\n"
      generated_expected_text = "hello\nhello\nhello\n"

      check_source_and_remove_gen( source, generated )
      check_source_text( source, source_expected_text )

      # run CLI (With blocking function)
      do_and_report("#{@prefix}/../bin/ruby_it --outpath #{@prefix}/../generated/ --file #{source}")

      check_generated_text( generated, generated_expected_text )
    end


    it "evaluates command line parameters" do
      source                  = "#{@prefix}/../examples/hellos.rtxt"
      generated               = "#{@prefix}/../generated/hellos.txt"
      source_expected_text    = "\n<% @hellos.times do -%>\n<%= 'Hello' %>\n<% end -%>\n"
      generated_expected_text = "Hello\nHello\nHello\n"

      check_source_and_remove_gen( source, generated )
      check_source_text( source, source_expected_text )

      # run CLI (With blocking function)
      do_and_report("#{@prefix}/../bin/ruby_it --parameter @hellos=3 --outpath #{@prefix}/../generated/ --file #{source}")

      check_generated_text( generated, generated_expected_text )
    end


    it "evaluates command line parameters with different values '5'" do
      source                  = "#{@prefix}/../examples/hellos.rtxt"
      generated               = "#{@prefix}/../generated/hellos.txt"
      source_expected_text    = "\n<% @hellos.times do -%>\n<%= 'Hello' %>\n<% end -%>\n"
      generated_expected_text = "Hello\nHello\nHello\nHello\nHello\n"

      check_source_and_remove_gen( source, generated )
      check_source_text( source, source_expected_text )

      # run CLI (With blocking function)
      do_and_report("#{@prefix}/../bin/ruby_it --parameter @hellos=5 --outpath #{@prefix}/../generated/ --file #{source}")

      check_generated_text( generated, generated_expected_text )
    end


    it "evaluates command line parameters with different values '5'" do
      source                  = "#{@prefix}/../examples/example3.rtxt"
      generated               = "#{@prefix}/../generated/example3.txt"
      source_expected_text    = "<%= @size %>\n<%= @name %>\n"
      generated_expected_text = "3\nHelloWorld\n"

      check_source_and_remove_gen( source, generated )
      check_source_text( source, source_expected_text )
      #puts "#{@prefix}/../bin/ruby_it --config #{@prefix}/../examples/example3.conf --outpath #{@prefix}/../generated/ --file #{source}"

      # run CLI (With blocking function)
      do_and_report("#{@prefix}/../bin/ruby_it --config #{@prefix}/../examples/example3.conf --outpath #{@prefix}/../generated/ --file #{source}")

      check_generated_text( generated, generated_expected_text )
    end



    it "Output is not writabe" do
      source                  = "#{@prefix}/../examples/example4.rtxt"
      generated               = "#{@prefix}/../examples/example4.txt"
      source_expected_text    = ""
      generated_expected_text = ""

      # Create output and chmod to 000
      ::File.delete( generated )
      ::File.open( generated, "w" ){ |f| f.write '' }
      ::File.chmod(0000, generated )

      # run CLI (With blocking function)
      require 'open3'
      stdin, stdout, stderr = Open3.popen3("#{@prefix}/../bin/ruby_it --file #{source}")

      #puts stdout.readlines
      stderr.readlines[0].strip.should == "ERROR #{generated} is not writable"
    end

  end
end


def do_and_report(command, report=false)
  f = open("| #{command}")
  g = Array.new
  while (foo = f.gets)
    g << foo
  end
  if report
    g.each do |element|
      puts element
    end
  end
  return g
end

def check_source_and_remove_gen( source, generated )
  #Check file exists
  File.exists?( source ).should == true

  if File.exists?( generated )
    File.delete( generated )
  end 
end

def check_source_text(source, expected_text )
  #Check correct file read
  source_text = ''
  File.open( source, 'r') do |source_file|  
    while line = source_file.gets  
      source_text << line  
    end  
  end  
  source_text.should == expected_text
end

def check_generated_text( generated, expected_text )
  # Check output file exists
  File.exists?( generated ).should == true

  # check output
  generated_text = ''
  File.open( generated, 'r') do |generated_file|  
    while line = generated_file.gets  
      generated_text << line  
    end  
  end

  generated_text.should == expected_text
end

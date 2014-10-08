require 'spec_helper'
#Run from the Spec Folder
#Dir.chdir( File.dirname( __FILE__ ) )


describe RubyIt do
  before(:all) do
    @prefix   = File.dirname( __FILE__ )
    @fixtures = File.join( File.dirname( __FILE__ ), 'fixtures' ) 
  end


  describe RubyIt, "RubyIt" do
    it "hello_erb basic load and parse" do
      rubyit = RubyIt::Document.new("#{@prefix}/../examples/hello_erb.rtxt")

      rubyit.input.should  == "#{@prefix}/../examples/hello_erb.rtxt"
      rubyit.output.should == "#{@prefix}/../examples/hello_erb.txt"
      rubyit.path.should   == "#{@prefix}/../examples/"

      rubyit.erb_text.should == "\n<% 3.times do -%>\n<%= 'hello' %>\n<% end -%>\n"

      rubyit.result.should   == "hello\nhello\nhello\n"
    end
  end

  describe RubyIt, "#clean_whitespace" do
    it "testing whitespace <%" do
      rubyit = RubyIt::Document.new("#{@prefix}/../examples/hello_erb.rtxt")
      text = rubyit.clean_whitespace( "   <%" )
      text.should == '<%'

      text = rubyit.clean_whitespace( "\t\t<%" )
      text.should == '<%'

      text = rubyit.clean_whitespace( " \t \t<%" )
      text.should == '<%'
    end
  end

  describe RubyIt, "#clean_whitespace" do
    it "testing whitespace <%=" do
      ## <%= not modified
      rubyit = RubyIt::Document.new("#{@prefix}/../examples/hello_erb.rtxt")
      text = rubyit.clean_whitespace( "   <%=" )
      text.should == '   <%='

      text = rubyit.clean_whitespace( "\t<%=" )
      text.should == "\t<%="

      text = rubyit.clean_whitespace( " \t \t<%=" )
      text.should == " \t \t<%="
    end
  end

  describe RubyIt, "#clean_whitespace" do
    it "testing whitespace -%>" do
      rubyit = RubyIt::Document.new("#{@prefix}/../examples/hello_erb.rtxt")
      text = rubyit.clean_whitespace( " -%>   " )
      text.should == ' %>   '

      text = rubyit.clean_whitespace( " -%>\t" )
      text.should == " %>\t"

      text = rubyit.clean_whitespace( " -%>\n" )
      text.should == " %>"

      text = rubyit.clean_whitespace( " -%> \n" )
      text.should == " %>"

      text = rubyit.clean_whitespace( " -%>\t\n" )
      text.should == " %>"

      text = rubyit.clean_whitespace( " -%> \t \t \n" )
      text.should == " %>"

      #Only remove one line return
      text = rubyit.clean_whitespace( " -%>\n\t \t\n \n \t " )
      text.should == " %>\t \t\n \n \t " 
    end
  end

  describe RubyIt, "#clean_whitespace" do
    it "testing whitespace -%> not on blank line" do
      ## <%= not modified
      rubyit = RubyIt::Document.new("#{@prefix}/../examples/hello_erb.rtxt")
      text = rubyit.clean_whitespace( " -%>   boo" )
      text.should == ' %>   boo'

      text = rubyit.clean_whitespace( " -%>\t boo" )
      text.should == " %>\t boo"

      text = rubyit.clean_whitespace( " -%>\n boo" )
      text.should == " %> boo"

      text = rubyit.clean_whitespace( " -%>\t \t\n\t \t\n \n \t boo" )
      text.should == " %>\t \t\n \n \t boo" 
    end
  end

  ## TODO Complete this test
  describe RubyIt, "erb output to file" do
    it "example2.erb" do
      rubyit = RubyIt::Document.new("#{@prefix}/../examples/hello_erb.rtxt")
      #load file and then make sure it is as expected

    end
  end


  #Check output redirection
  describe RubyIt, "Outut file redirection" do
    it "set output to ../generated" do
      rubyit = RubyIt::Document.new("#{@prefix}/../examples/hellos.rtxt", '', "#{@prefix}/../generated")
      rubyit.input.should  == "#{@prefix}/../examples/hellos.rtxt"
      rubyit.output.should == "#{@prefix}/../generated/hellos.txt"
      rubyit.path.should   == "#{@prefix}/../generated/"
    end

    it "Redirect output after intialisation" do
      rubyit = RubyIt::Document.new("#{@prefix}/../examples/hellos.rtxt", '', "#{@prefix}/../generated")
      rubyit.out_filename  = "hellos_renamed.txt"

      rubyit.input.should  == "#{@prefix}/../examples/hellos.rtxt"
      rubyit.output.should == "#{@prefix}/../generated/hellos_renamed.txt"
      rubyit.path.should   == "#{@prefix}/../generated/"
    end
  end

  #Check set_parameter and get_parameters
  describe RubyIt, "set and get params" do
    it "set and get params" do
      rubyit = RubyIt::Document.new("#{@prefix}/../examples/hellos.rtxt")
      rubyit.add_parameter( '@a = 4' )
      rubyit.add_parameter( '@b = 5' )
      rubyit.add_parameter( '@c = 6' )
      params = rubyit.get_parameters
      params.should == "<% @a = 4 \n @b = 5 \n @c = 6 \n  -%>"
    end
  end


  #Check setting variables for generated erb content
  describe RubyIt, "variables inserted into erb" do
    it "say 3 Hellos" do
      rubyit = RubyIt::Document.new("#{@prefix}/../examples/hellos.rtxt")
      rubyit.add_parameter( '@hellos = 3' )

      rubyit.input.should  == "#{@prefix}/../examples/hellos.rtxt"
      rubyit.output.should == "#{@prefix}/../examples/hellos.txt"
      rubyit.path.should   == "#{@prefix}/../examples/"

      rubyit.erb_text.should == "\n<% @hellos.times do -%>\n<%= 'Hello' %>\n<% end -%>\n"
      #puts  rubyit.result
      rubyit.result.should   == "Hello\nHello\nHello\n"

    end
    it "say 4 hellos" do 
      rubyit = RubyIt::Document.new("#{@prefix}/../examples/hellos.rtxt")
      rubyit.add_parameter( '@hellos = 4' )
      rubyit.result.should   == "Hello\nHello\nHello\nHello\n"

    end
    it "say 0 hellos" do
      rubyit = RubyIt::Document.new("#{@prefix}/../examples/hellos.rtxt")
      rubyit.add_parameter( '@hellos = 0' )
      rubyit.result.should   == ""

    end
  end

  describe RubyIt, "Test Error Reporting" do
    it "undefined variable on line 2" do
      rubyit = RubyIt::Document.new("#{@fixtures}/hellos_broken.rtxt")
      error1 = %{Error parsing #{@fixtures}/hellos_broken.rtxt on line 2}
      error2 = %{undefined local variable or method `hellos' for main:Object}
      $stderr.should_receive(:puts).with( error1 )
      #$stderr.should_receive(:puts).with( error2 )
      lambda { rubyit.result }.should raise_error(NameError)
    end
  end


end
#Check file creation

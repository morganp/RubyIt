
require "erb"
require 'pp'

module RubyIt
  class Document 

    attr_accessor :input
    attr_accessor :out_filename
    attr_accessor :path

    def initialize(f_in, output='', path='')
      if not f_in.index('.r') then
        puts "ERROR input #{f_in} not of form y.rz were output should be y.z"
        exit 1
      end
      @input        = f_in
      @path         = set_path( path )
      @out_filename = set_out_file( output )
    end


    def erb_text
      @erb_text ||= File.read( @input )
    end 

    def to_s
      return "File: " +@input.to_s + " Output: " + @path.to_s + @output.to_s 
    end

    def result
      #Giving The template file acces to the parent object
      $parent = self ## <-- Global bad, but works for this

      #Add params and template file text and clear white space
      text   =  clean_whitespace( get_parameters + erb_text )

      @result ||= erb_conversion( text ) 
    end

    def clean_whitespace( erb_text )
      ##Remove leading white space
      text = erb_text.gsub(/[ \t]*<%(?!=)/, "<%")

      ## Remove white space and line return followed by -%> and convert to erb %>
      text = text.gsub(/-%>([ \t]*[\n\r])?/, "%>")

      return text
    end

    def erb_conversion( erb_text )
      begin
        return ERB.new(erb_text, 0, "%").result
      rescue => error
        first_line = error.backtrace[0]
        if first_line.match(/\(erb\)\W*(\d*)/)
          $stderr.puts "Error parsing #{@input} on line #{$1}"
        else
          $stderr.puts "Error parsing #{@input}"
        end
        $stderr.puts error
        fail

      end
    end

    def add_parameter( param )
      @erb_parameters ||= Array.new
      Array(param).each do |line|
       @erb_parameters << line
      end
    end

    def get_parameters
      parameter_string = '<% '

      #Skip if parameters not defined
      if not @erb_parameters.nil?
        @erb_parameters.each do |param|
          parameter_string <<  param + " \n "
        end
        parameter_string << ' -%>'

      else
        #No Params have been set add comment and close erb tags
        parameter_string << ' #no parameters %>'
      end

      return parameter_string
    end

    def output
      return @path + @out_filename
    end


    def write
      #write evaluated template to file:
      if ::File.writable? self.output or not ::File.exists? self.output
      
        result   = self.result
        file_out = File.open( self.output, 'w' )
        file_out << result
        file_out.close
        
      else
        $stderr.puts "ERROR #{self.output} is not writable"
      end
      
    end

    private

    def set_out_file( filename )
      if filename == '' then
        #Remove path
        filename   = File.basename( @input ) #@input.clone

        #Remove .r ie readme.rtxt becomes readme.txt
        pos      = filename.rindex('.r')
        filename[pos..pos+1] = '.'

      end
      return filename
    end

    def set_path(path)

      if path == ''  
        path = File.dirname( @input )
      end

      #Check redirectPath exists
      if File.directory? path then
        #If specified output does not end in / add it
        if not path =~ /\/$/ then
          path = path + "/"
        end
        if $verbose==1 then
          puts("Output redirection to #{path} \n")
        end
      else
        $stderr.puts("ERROR Output redirection path specified is not valid \n")
        $stderr.puts("#{path} is not a valid directory \n")
        #Set error code and exit
        exit 1
      end

      return path
    end

  end
end

require 'optparse'
   require 'optparse/time'
   require 'ostruct'


module RubyIt
  class RubyItOptions

    #
    # Return a structure describing the options.
    #
    def self.parse(args)
      # The options specified on the command line will be collected in *options*.
      # We set default values here.
      options = OpenStruct.new

      $verbose                = false
      options.version         = RubyIt::VERSION
      options.output_path     = ''

      ## Order of Precedence 
      #Commandline overrides Data file

      options.data            = Array.new
      options.parameters      = Array.new

      options.output_filename = ''
      options.filelist        = Array.new



      opts = OptionParser.new do |opts|
        opts.banner = "Usage: #{__FILE__} [options] -p ../generated/ -f ../templates/input.rhtml
         Multiple -c, -p, -o and -f may be used but -f will use preceding -p and -o options"

        opts.separator ""
        opts.separator "Common options:"

        # No argument, shows at tail.  This will print an options summary.
        opts.on("-h", "--help", "Show this message") do
          puts opts
          exit
        end

        # Another typical switch to print the version.
        opts.on("--version", "Show version") do
          #puts OptionParser::Version.join('.')
          puts "Version " + options.version
          exit
        end

        # Specify Input Templates
        opts.on("-f", "--file input_filename", String, "Input source file to evaluate") do |input_filename|
          
          # TODO How to insert command line parameters (options.parameters)

          options.input_filename = input_filename

          temp =  RubyIt::Document.new(input_filename, options.output_filename, options.output_path)
          temp.add_parameter( options.parameters )
          
          options.filelist << temp
          # Setting the output_filename is only valid for one input file
          options.output_filename = ""
        end

        opts.separator ""
        opts.separator "Specific options:"

        # Control Verbosity
        opts.on("-v", "--[no-]verbose", "Run Verbosely") do |v|
          $verbose = v
        end
        opts.on("-q", "--quiet", "Run Quiet, not Verbose") do |v|
          $verbose = 0
        end

        # Specify command line arguments ie --parameter @hellos=3
        opts.on("--parameter param", String, "Command line parameters (Override data file settings)") do |param|
          pp param
          options.parameters << param
        end

        # Specify Config Files
        opts.on("-c", "--config config_data", String, "Load Config File") do |data|
          options.data << data
        end


        # Specify Output path if not the same as input
        opts.on("-p", "--outpath output_path", String, "Redirect generated file output") do |path|
          options.output_path = path
        end

        # Rename output if different from input
        opts.on("-o", "--out output_filename", String, "Define different generated filename from source file") do |new_name|
          options.output_filename = new_name
        end


      end

      options.leftovers = opts.parse!(args)
      options
    end  # parse()

  end  # class OptparseExample
end

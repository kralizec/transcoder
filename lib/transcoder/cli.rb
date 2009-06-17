class Transcoder

  # Contains CLI options parsing rules.
  class CLI < Hash

    # Singleton methods
    class << self

      # Execute a cli instance of the transcoder.
      def run!(args)

        # TODO Load the default ENV options.
        # TODO Load config file.

        # Process the CLI options
        options = Transcoder::CLI.new(args)
        #print options.inspect

        # Create a new profiles container.
        profiles = Transcoder::Profiles.new(options)

        begin
         
          trans = Transcoder.new(profiles, options)

          case(options[:cmd])
		when :info
			trans.info
		when :list
			profiles.list(options[:device])
		when :transcode
			trans.convert
		else
			abort("Please specify an appropiate command!")
          end

          return 0

        #rescue
        #  print "ERROR!\n"
        #  print "#{$!}\n"
        #  return 1
        end

      end

    end

    # Initialize the options system.
    def initialize(args)
      super()

      # Options hash
      options = {
	:cmd => :info
      }

      # Create a new options parser.
      opts = OptionParser.new


      # Section separator
      opts.separator " "
      opts.separator "Transcoding Options"

      # Input file option.
      opts.on('-i FILEPATH', '--infile FILEPATH', String, 'The source media file.') do |infile|
        raise(Transcoder::MissingFile, "The input file is missing or not a regular file.") if !File.file?(infile)
        options[:cmd] = :transcode
	options[:infile] = infile
      end

      # Output file option.
      # TODO: Check for collisions with existing files, with a separate case for collisions with the source file.
      opts.on('-o FILEPATH', '--out FILEPATH', String, 'The destination media file.') do |outfile|
        raise(FileExists, "The output file already exists!") if !File.file?(outfile)
        options[:outfile] = outfile
      end

      # Device option
      # TODO: Rename this (or add a target option)? we may have targets other than devices, after all.
      opts.on('-d DEVICE', '--device DEVICE', String, 'The target device.') do |device|
        # TODO: Check to see if the device exists.
        options[:device] = device
      end

      # Section separator
      opts.separator " "
      opts.separator "Configuration Options"

      opts.on('-D', '--defaults', 'Use the default settings for the target.', 'No attempts to adjust for the', 'source type will be made.') do
        options[:defaults] = true
      end

      # TODO: Metadata analysis options.

      # Section separator
      opts.separator " "
      opts.separator "Info Options"

      # TODO: Load profiles from...

      opts.on('-l [DEVICE]', '--list [DEVICE]', String, 'List supported devices.', 'If a DEVICE is specified, ', 'print brief info about its supported modes.') do |device|

	options[:cmd] = :list
 	options[:device] = device unless device.nil?

      end

      opts.on_tail('-h', '--help') do |category|
        # TODO: Help categories.
        puts opts
        exit
      end

      # Process the options
      opts.parse!(args)

      # Merge the set options into this object.
      merge!(options);

    end


  end


end


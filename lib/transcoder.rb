
require 'rubygems'
require 'yaml'

require 'transcoder/errors'

require 'transcoder/profiles'
require 'transcoder/profiles/devices'
require 'transcoder/profiles/device/modes'
require 'transcoder/profiles/device/metadata'

require 'transcoder/cli'
require 'transcoder/utils'
require 'transcoder/ffmpeg'
require 'transcoder/mencoder'


# Transcoder handles video and audio conversion from a variety of source types
# to device optimized versions.
class Transcoder

  def initialize(infile, outfile = nil, device = :ipod_touch, device_mode = 0)

    # Load the device profiles.
    @profiles = YAML::load_file( File.expand_path('lib/device_profiles.yml') )

    # TODO: Get rid of this
    device = device.to_sym

    raise(MissingFile, "The input file is not a regular file.") if !File.file?(infile)
    raise(InvalidDevice, "Target device not specified or invalid.") if device.nil? or !@profiles.key?(device)

    @infile = infile
    @outfile = outfile ? outfile : "test_out"
    @device = device

    # Load the device profiles.
    #@profiles = YAML::load_file( File.expand_path('lib/device_profiles.yml') )

  end

  # Prints available device profiles for transcoding operations.
  def info

    puts "==================\n"
    puts @profiles[:device]
    puts @profiles[:description]

    @profiles[:modes].each do |mode|
      mode.each_pair do |k,v|
        puts "  #{k} -- #{v}"
      end
    end
    puts "==================\n"

  end

  # Run the actual conversion.
  def convert

    # Select the conversion mode
    # TODO/FIXME: only one config is present.
    profile = @profiles[@device][:modes][0]

    # Run the conversion
    case profile[:encoder]
    when :ffmpeg
      exec_ffmpeg(@infile, @outfile, profile[:opts])
    when :mencoder
      exec_mencoder(@infile, @outfile, profile[:opts])
    else
      raise(InvalidEncoder, "The encoder specified is neither ffmpeg nor mencoder.")
    end

    # Adjust the metadata

  end

end


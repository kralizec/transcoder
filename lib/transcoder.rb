
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

  def initialize(profiles, options = {})

    @profiles = profiles
    @options = options

  end

  # Prints available device profiles for transcoding operations.
  def info
    @profiles.list_devices unless @profiles.nil?
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


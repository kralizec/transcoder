class Transcoder
  class Profiles

    attr_accessor :devices

    def initialize(options={})

      # Locally reference the options.
      @options = options

      # Load the profiles
      # TODO: Configurable profile loading.
      @devices = YAML::load_file( File.expand_path('lib/device_profiles.yml') )

      # Mix in some methods with the retrieved YAML hash for utility purposes.
      @devices.extend Devices
      @devices.each_pair do |key, device|
        device.extend Device

        # Also add the device name to the device objects.
        device[:name] = key

        device.modes.extend Device::Modes
        device.modes.each do |mode|
          mode.extend Device::Mode
        end

      end

      # List Devices
      def list_devices
        @devices.info(0,"  ")
      end

      # List device info
      def list(device)
        
        unless @devices[device]
          raise(Transcoder::InvalidDevice, "Specified device does not exist! #{device}\n")
          return
        end

        @devices[device].info(0, "  ")
        @devices[device].modes.info(0, "  ")
      end


    end

  end
end


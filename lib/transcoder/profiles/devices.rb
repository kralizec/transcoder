class Transcoder
  class Profiles
    
    # Target device
    module Device
    
      def info(depth = 0, indent = " ")
        offset_str = indent * depth
        print offset_str + "Device Name: #{self[:name]}\n"
        print offset_str + "Description: #{self[:description]}\n"
      end

      def name
        self[:name]
      end

      def description
        self[:description]    
      end
      
      def display
        self[:display]
      end

      def audio
        self[:audio]
      end

      def modes
        self[:modes]
      end

    end

    module Devices
      
      def info(depth = 0, indent = " ")
        offset_str = indent * depth
        print offset_str + "Contains #{self.size} device profiles.\n"
        self.values.each do |device|
          device.info(depth+1, indent)
        end
      end

    end

  end
end


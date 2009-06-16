class Transcoder
  class Profiles
    module Device

      module Mode
        #attr_accessor :name, :encoder, :description, :opts

        # Print information regarding this mode.
        def info(depth = 0, indent = " ")
          offset_str = indent * depth
          print offset_str + "Name: #{self[:name]}\n"
          print offset_str + "Encoder: #{self[:encoder]}\n"
          print offset_str + "Description: #{self[:description]}\n"
        end

        def description
          self[:description]
        end

        def name
          self[:name]
        end

        def encoder
          self[:encoder]
        end

        def opts
          self[:opts]
        end

      end

      # Device transcoding modes.
      module Modes

        def info(depth = 0, indent = " ")
          offset_str = indent * depth
          print offset_str + "Contains #{self.size} modes\n"
          self.each do |mode|
            mode.info(depth+1,indent)
          end
        end

      end
    end
  end
end


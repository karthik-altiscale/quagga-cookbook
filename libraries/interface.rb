module Quagga
  class Interface
    def initialize(int_name, netns = nil)
      @int_name = int_name
      @netns = netns
      @vtysh_interface = Quagga::Vtysh::Interface.new(@netns)
    end

    def state
      match = /Interface lo is (up|down).*/.match(@vtysh_interface.show_interface(@int_name))
      return nil unless match
      return true if match[1] == 'up'
      return false if match[1] == 'down'
      raise "Interface state #{match[1]} is neither up nor down"
    end

    def state=(state)
      state ? @vtysh_interface.no_shut(@int_name) : @vtysh_interface.shutdown(@int_name)
    end
  end
end

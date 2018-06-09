module Quagga
  module Vtysh
    class Base
      def initialize(netns = nil)
        @netns = netns
      end

      private

      def vtysh(cmds)
        vtysh_cmd = @netns ? "vtysh-#{@netns}" : 'vtysh'
        cmd = vtysh_cmd + ' -c "' + cmds.join('" -c "') + '"'
        Quagga::Utils.shellout(cmd)
      end
    end

    class Interface < Base
      def shutdown(int)
        vtysh(['conf t', "interface #{int}", 'shutdown'])
      end

      def no_shut(int)
        vtysh(['conf t', "interface #{int}", 'no shut'])
      end

      def show_interface(int)
        vtysh(["show interface #{int}"])
      end
    end
  end
end

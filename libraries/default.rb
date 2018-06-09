module Quagga
  class Utils
    def self.shellout(cmd)
      run = Mixlib::ShellOut.new(cmd)
      run.run_command
      if run.error? || run.exitstatus != 0
        raise "#{cmd} failed: \n ----- stderr ----- \n #{run.stderr} \n ------ stdout ----- \n #{run.stdout}"
      end
      run.stdout
    end
  end
end

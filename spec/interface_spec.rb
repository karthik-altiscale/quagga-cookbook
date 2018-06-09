require 'spec_helper'
require_relative '../libraries/vtysh'
require_relative '../libraries/interface'
require_relative '../libraries/default'

describe 'quagga' do
  let(:shellout) { double('shellout') }

  before do
    allow(shellout).to receive(:run_command)
    allow(shellout).to receive(:error?)
    allow(shellout).to receive(:exitstatus).and_return(0)
    allow(shellout).to receive(:stdout)
  end

  describe 'class Quagga::Vtysh::Interface' do
    context 'when no netns' do
      let(:vtysh) { Quagga::Vtysh::Interface.new() }

      it 'shuts down an interface' do
        expect(Mixlib::ShellOut).to receive(:new)
          .with('vtysh -c "conf t" -c "interface lo" -c "shutdown"').and_return(shellout)
        vtysh.shutdown('lo')
      end
    end

    context 'when netns' do
      let(:vtysh) { Quagga::Vtysh::Interface.new('ns') }

      it 'shuts down an interface' do
        expect(Mixlib::ShellOut).to receive(:new)
          .with('vtysh-ns -c "conf t" -c "interface lo" -c "shutdown"').and_return(shellout)
        vtysh.shutdown('lo')
      end
    end
  end

  describe 'class Quagga::Interface' do
    let(:interface) { Quagga::Interface.new('lo') }

    context 'when no netns' do
      it 'returns interface down state' do
        allow(Mixlib::ShellOut).to receive(:new).with('vtysh -c "show interface lo"').and_return(shellout)
        allow(shellout).to receive(:stdout).and_return('Interface lo is down
  index 1 metric 1 mtu 65536
  flags: <LOOPBACK>
  inet 127.0.0.1/8')
        expect(interface.state).to be_falsey
      end

      it 'returns interface up state' do
        allow(Mixlib::ShellOut).to receive(:new).with('vtysh -c "show interface lo"').and_return(shellout)
        allow(shellout).to receive(:stdout).and_return('Interface lo is up, line protocol detection is disabled
  index 1 metric 1 mtu 65536
  flags: <UP,LOOPBACK,RUNNING>
  inet 127.0.0.1/8')
        expect(interface.state).to be_truthy
      end

      it 'sets interface state to up' do
        expect(Mixlib::ShellOut).to receive(:new)
          .with('vtysh -c "conf t" -c "interface lo" -c "shutdown"').and_return(shellout)
        interface.state = false
      end
    end

    context 'when netns' do
      let(:interface) { Quagga::Interface.new('lo', 'ns') }

      it 'sets interface state to up' do
        expect(Mixlib::ShellOut).to receive(:new)
          .with('vtysh-ns -c "conf t" -c "interface lo" -c "no shut"').and_return(shellout)
        interface.state = true
      end
    end
  end
end

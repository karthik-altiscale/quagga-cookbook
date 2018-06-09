provides :q_interface

# property :name, String, name_property: true
property :shutdown, [TrueClass, FalseClass]

load_current_value do |current|
  int = Quagga::Interface.new(current.name)
  shutdown int.state
  # ip_addr int.ip_addr.include?(current.ip_addr) ? current.ip_addr : nil
  # description int.description
end

action :add do
  int = Quagga::Interface.new(new_resource.name)
  converge_if_changed(:shutdown) { int.state = new_resource.shutdown }
end

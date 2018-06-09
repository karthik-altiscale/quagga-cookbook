
if node['quagga']['version']
  package 'quagga' do
    action :install
    version node['quagga']['version']
  end
else
  package 'quagga' do
    action :upgrade
  end
end

service 'zebra' do
  action [:start, :enable]
  not_if node['quagga']['netns']
end

# # encoding: utf-8

# Inspec test for recipe quaggans::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe package('quagga') do
  it { should be_installed }
end

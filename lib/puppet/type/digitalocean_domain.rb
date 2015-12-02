require 'puppet_x/garethr/digitalocean/property/boolean'

Puppet::Type.newtype(:digitalocean_domain) do
  @doc = 'Type representing a digitalocean domain'

  ensurable

  newparam(:name, namevar: true) do
    desc 'The name of the domain'
    validate do |value|
      fail 'Should not contains spaces' if value =~ /\s/
      fail 'Empty values are not allowed' if value == ''
    end
  end

  newproperty(:zone_file, :parent => PuppetX::Garethr::DigitalOcean::Property::ReadOnly) do
    desc 'The full DNS zone'
  end

  newproperty(:ttl, :parent => PuppetX::Garethr::DigitalOcean::Property::ReadOnly) do
    desc 'The time to live for records on the domain'
  end
end

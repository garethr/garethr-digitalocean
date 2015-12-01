require 'puppet_x/garethr/digitalocean/property/boolean'
require 'puppet_x/garethr/digitalocean/property/read_only'
require 'puppet_x/garethr/digitalocean/property/string'

Puppet::Type.newtype(:droplet) do
  @doc = 'Type representing a digitalocean droplet'

  ensurable

  newparam(:name, namevar: true) do
    desc 'The name of the droplet'
    validate do |value|
      fail 'Should not contains spaces' if value =~ /\s/
      fail 'Empty values are not allowed' if value == ''
    end
  end

  newproperty(:region, :parent => PuppetX::Garethr::DigitalOcean::Property::String) do
    desc 'The region in which the droplet will exist'
  end

  newproperty(:size, :parent => PuppetX::Garethr::DigitalOcean::Property::String) do
    desc 'The size of the droplet'
  end

  newproperty(:image, :parent => PuppetX::Garethr::DigitalOcean::Property::String) do
    desc 'The image to use for the droplet'
    def insync?(is)
      is.to_i == should.to_i
    end
  end

  newparam(:user_data) do
    desc 'The user data script to run on startup'
  end

  newproperty(:private_address, :parent => PuppetX::Garethr::DigitalOcean::Property::ReadOnly) do
    desc 'The private IPv4 address'
  end

  newproperty(:public_address, :parent => PuppetX::Garethr::DigitalOcean::Property::ReadOnly) do
    desc 'The public IPv4 address'
  end

  newproperty(:image_slug, :parent => PuppetX::Garethr::DigitalOcean::Property::ReadOnly) do
    desc 'The human friendly name for the image'
  end

  newproperty(:public_address_ipv6, :parent => PuppetX::Garethr::DigitalOcean::Property::ReadOnly) do
    desc 'The public IPv6 address'
  end

  newproperty(:price_monthly, :parent => PuppetX::Garethr::DigitalOcean::Property::ReadOnly) do
    desc 'The current monthly cost of the droplet'
  end

  newparam(:ssh_keys, :array_matching => :all) do
    defaultto []
    desc 'The ids of the ssh keys you want to embed in the droplet'
    munge do |value|
      [*value]
    end
  end

  newproperty(:backups, :parent => PuppetX::Garethr::DigitalOcean::Property::Boolean) do
    desc 'Whether or not backups are enabled'
    defaultto :false
  end

  newproperty(:ipv6, :parent => PuppetX::Garethr::DigitalOcean::Property::Boolean) do
    desc 'Whether ipv6 is enabled'
    defaultto :false
  end

  newproperty(:private_networking, :parent => PuppetX::Garethr::DigitalOcean::Property::Boolean) do
    desc 'Whether private networking is enabled'
    defaultto :false
  end
end

require 'puppet/parameter/boolean'

Puppet::Type.newtype(:droplet) do
  @doc = 'type representing a digitalocean droplet'

  ensurable

  newparam(:name, namevar: true) do
    desc 'the name of the droplet'
    validate do |value|
      fail Puppet::Error, 'Should not contains spaces' if value =~ /\s/
      fail Puppet::Error, 'Empty values are not allowed' if value == ''
    end
  end

  newproperty(:region) do
    desc 'the region in which the droplet will exist'
    validate do |value|
      fail Puppet::Error, 'Should not contains spaces' if value =~ /\s/
      fail Puppet::Error, 'Empty values are not allowed' if value == ''
    end
  end

  newproperty(:size) do
    desc 'the size of the droplet'
    validate do |value|
      fail Puppet::Error, 'Should not contains spaces' if value =~ /\s/
      fail Puppet::Error, 'Empty values are not allowed' if value == ''
    end
  end

  newproperty(:image) do
    desc 'the image to use for the droplet'
    validate do |value|
      fail Puppet::Error, 'Should not contains spaces' if value =~ /\s/
      fail Puppet::Error, 'Empty values are not allowed' if value == ''
    end
  end

  newproperty(:ssh_keys, :array_matching => :all) do
    defaultto []
    desc 'the ids of the ssh keys you want to embed in the droplet'
  end

  newproperty(:backups, :boolean => true, :parent => Puppet::Parameter::Boolean) do
    defaultto :false
    desc 'whether or not backups are enabled'
  end

  newproperty(:ipv6, :boolean => true, :parent => Puppet::Parameter::Boolean) do
    defaultto :false
    desc 'whether ipv6 is enabled'
  end

  newproperty(:private_networking, :boolean => true, :parent => Puppet::Parameter::Boolean) do
    defaultto :false
    desc 'whether private networking is enabled'
  end

end

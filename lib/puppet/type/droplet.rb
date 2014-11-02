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

  newparam(:size) do
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
    def insync?(is)
      is.to_i == should.to_i
    end
  end

  newparam(:user_data) do
    desc 'the user data script to run on startup'
  end

  newproperty(:private_address) do
    desc 'The private IPv4 address'
  end

  newproperty(:public_address) do
    desc 'The public IPv4 address'
  end

  newparam(:ssh_keys, :array_matching => :all) do
    defaultto []
    desc 'the ids of the ssh keys you want to embed in the droplet'
    munge do |value|
      [*value]
    end
  end

  newparam(:backups, :boolean => true, :parent => Puppet::Parameter::Boolean) do
    defaultto :false
    desc 'whether or not backups are enabled'
  end

  newparam(:ipv6, :boolean => true, :parent => Puppet::Parameter::Boolean) do
    defaultto :false
    desc 'whether ipv6 is enabled'
  end

  newparam(:private_networking, :boolean => true, :parent => Puppet::Parameter::Boolean) do
    defaultto :false
    desc 'whether private networking is enabled'
  end

end

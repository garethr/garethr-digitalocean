Puppet::Type.newtype(:droplet) do
  @doc = 'type representing a digitalocean droplet'

  ensurable

  newparam(:name, namevar: true) do
    desc 'the name of the droplet'
  end

  newparam(:region) do
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

  newparam(:image) do
    desc 'the image to use for the droplet'
    validate do |value|
      fail Puppet::Error, 'Should not contains spaces' if value =~ /\s/
      fail Puppet::Error, 'Empty values are not allowed' if value == ''
    end
  end

end

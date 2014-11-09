Puppet::Type.newtype(:digitalocean_domain) do
  @doc = 'type representing a digitalocean domain'

  ensurable

  newparam(:name, namevar: true) do
    desc 'the name of the domain'
    validate do |value|
      fail 'Should not contains spaces' if value =~ /\s/
      fail 'Empty values are not allowed' if value == ''
    end
  end

  newproperty(:zone_file) do
    desc 'the full DNS zone'
    validate do |value|
      fail 'Zone is read-only'
    end
  end

  newproperty(:ttl) do
    desc 'the time to live for records on the domain'
    validate do |value|
      fail 'TTL is read-only'
    end
  end

end

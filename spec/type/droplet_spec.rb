droplet = Puppet::Type.type(:droplet)

describe droplet do

  let :params do
    [
      :name,
      :provider
    ]
  end

  let :properties do
    [
      :ensure,
      :region,
      :size,
      :image,
      :ssh_keys,
      :backups,
      :ipv6,
      :private_networking
    ]
  end

  it 'should have expected properties' do
    properties.each do |property|
      droplet.properties.map { |p| p.name }.should be_include(property)
    end
  end

  it 'should have expected parameters' do
    params.each do |param|
      droplet.parameters.should be_include(param)
    end
  end
end

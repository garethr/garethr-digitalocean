droplet = Puppet::Type.type(:droplet)

describe droplet do
  let :params do
    [
      :name,
      :provider,
      :user_data,
      :ssh_keys
    ]
  end

  let :properties do
    [
      :ensure,
      :image,
      :region,
      :size,
      :backups,
      :ipv6,
      :private_networking
    ]
  end

  it 'should have expected properties' do
    properties.each do |property|
      expect(droplet.properties.map(&:name)).to be_include(property)
    end
  end

  it 'should have expected parameters' do
    params.each do |param|
      expect(droplet.parameters).to be_include(param)
    end
  end
end

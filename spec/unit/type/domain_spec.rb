droplet = Puppet::Type.type(:digitalocean_domain)

describe droplet do
  let :params do
    [
      :name,
    ]
  end

  let :properties do
    [
      :ensure,
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

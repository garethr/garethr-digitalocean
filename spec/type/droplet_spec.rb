droplet = Puppet::Type.type(:droplet)

describe droplet do

  let :params do
    [
      :name,
      :region,
      :size,
      :image,
      :backups,
      :ipv6,
      :private_networking
    ]
  end

  it 'should have expected parameters' do
    params.each do |param|
      droplet.parameters.should be_include(param)
    end
  end
end

droplet = Puppet::Type.type(:droplet)

describe droplet do

  let :params do
    [
      :name,
      :region,
      :size,
      :image
    ]
  end

  it 'should have expected parameters' do
    params.each do |param|
      droplet.parameters.should be_include(param)
    end
  end
end

require 'spec_helper'

provider_class = Puppet::Type.type(:droplet).provider(:v2)

ENV['DIGITALOCEAN_ACCESS_TOKEN'] = 'random'

describe provider_class do

  context 'with the minimum params' do
    before(:all) do
      @resource = Puppet::Type.type(:droplet).new(
        name: 'rod',
        region: 'lon1',
        size: '512mb',
        image: 123456,
        backups: true
      )
      @provider = provider_class.new(@resource)
    end

    it 'should be an instance of the ProviderV2' do
      @provider.should be_an_instance_of Puppet::Type::Droplet::ProviderV2
    end

    it 'should expose backups? as true' do
      @resource['backups'].should be true
    end

    it 'should default private_networking and ipv6 to false' do
      @resource['ipv6'].should be false
      @resource['private_networking'].should be false
    end

    context 'exists?' do
      it 'should correctly report non-existent droplets' do
        stub_request(:get, 'https://api.digitalocean.com/v2/droplets?per_page=200')
          .to_return(body: '{"droplets": [ {"name": "jane"}]}')
        @provider.exists?.should be false
      end

      it 'should correctly find existing droplets' do
        stub_request(:get, 'https://api.digitalocean.com/v2/droplets?per_page=200')
          .to_return(body: '{"droplets": [ {"name": "rod"}]}')
        @provider.exists?.should be true
      end
    end

    context 'create' do
      it 'should send a request to the digitalocean API to create droplet' do
        stub_request(:post, 'https://api.digitalocean.com/v2/droplets')
          .with(body: '{"name":"rod","region":"lon1","size":"512mb","image":123456,"ssh_keys":[],"backups":true,"ipv6":false,"private_networking":false}')
        @provider.create
      end
    end

    context 'destroy' do
      it 'should send a request to the digital ocean API to destroy droplet' do
        droplet = mock('object')
        droplet.expects(:id).returns(1234)
        @provider.stubs(:_id_from_name).returns(droplet)
        stub_request(:delete, 'https://api.digitalocean.com/v2/droplets/1234')
        @provider.destroy
      end
    end

  end

  context 'with non-array ssh_keys' do
    it 'should be coerced to array' do
      @resource = Puppet::Type.type(:droplet).new(
        name: 'freddy',
        region: 'lon1',
        size: '512mb',
        image: 123456,
        ssh_keys: 1,
      )
      @provider = provider_class.new(@resource)
        stub_request(:post, 'https://api.digitalocean.com/v2/droplets')
          .with(body: '{"name":"freddy","region":"lon1","size":"512mb","image":123456,"ssh_keys":[1],"backups":false,"ipv6":false,"private_networking":false}')
      @provider.create
    end
  end

end

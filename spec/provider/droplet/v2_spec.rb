require 'spec_helper'

provider_class = Puppet::Type.type(:droplet).provider(:v2)

describe provider_class do

  before do
    @resource = Puppet::Resource.new(:droplet, 'sdsfdssdhdfyjymdgfcjdfjxdrssf')
    @provider = provider_class.new(@resource)
  end

  describe 'parse' do
    it 'should do something' do
    end
  end

end

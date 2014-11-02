require 'barge'
require 'base64'

Puppet::Type.type(:droplet).provide(:v2) do
  confine feature: :barge

  mk_resource_methods

  def initialize(*args)
    @client = self.class.client
    super(*args)
  end

  def self.client
    Barge::Client.new(access_token: ENV['DIGITALOCEAN_ACCESS_TOKEN'])
  end

  def self.instances
    client.droplet.all.droplets.collect do |droplet|
      new(droplet_to_hash(droplet))
    end
  end

  def self.prefetch(resources)
    instances.each do |prov|
      if resource = resources[prov.name]
        resource.provider = prov
      end
    end
  end

  def self.droplet_to_hash(droplet)
    {
      name: droplet.name,
      region: droplet.region.slug,
      size: droplet.size,
      image: droplet.image.id,
      ssh_keys: droplet.ssh_keys,
      backups: droplet.backups,
      ipv6: droplet.ipv6,
      private_networking: droplet.private_networking,
      ensure: :present,
    }
  end

  def exists?
    Puppet.info("Checking if droplet #{resource[:name]} exists")
    @property_hash[:ensure] == :present
  end

  def create
    response = @client.droplet.create(
      name: resource[:name],
      region: resource[:region],
      size: resource[:size],
      image: resource[:image],
      user_data: resource[:user_data],
      ssh_keys: resource[:ssh_keys],
      backups: resource[:backups],
      ipv6: resource[:ipv6],
      private_networking: resource[:private_networking])
    if response.success?
      Puppet.info("Created new droplet called #{resource[:name]}")
    else
      fail('Failed to create droplet')
    end
  end

  def destroy
    Puppet.info("Destroying droplet #{resource[:name]}")
    droplet = _droplet_from_name resource[:name]
    if droplet
      response = @client.droplet.destroy(droplet.id)
      fail('Failed to destroy droplet') unless response.success?
      @property_hash[:ensure] = :absent
    end
  end

  private

  def _droplet_from_name(name)
    @client.droplet.all.droplets.find { |droplet| droplet.name == name }
  end

end

require 'barge'

class Puppet::Provider::Droplet < Puppet::Provider

  def initialize(*args)
    @client = Barge::Client.new(access_token: ENV['DIGITALOCEAN_ACCESS_TOKEN'])
    super(*args)
  end

  def exists?
    Puppet.debug("Checking if droplet #{resource[:name]} exists")
    _id_from_name(resource[:name]) ? true : false
  end

  def create
    Puppet.info("Creating new droplet")
    response = @client.droplet.create(
      name: resource[:name],
      region: resource[:region],
      size: resource[:size],
      image: resource[:image])
    if response.success?
      Puppet.info("Created new droplet called #{resource[:name]}")
    else
      Puppet.error("Failed to create droplet")
    end
  end

  def destroy
    Puppet.info("Destroying droplet #{resource[:name]}")
    droplet = _id_from_name resource[:name]
    if droplet
      response = @client.droplet.destroy(droplet.id)
      Puppet.error("Failed to destroy droplet") unless response.success?
    end
  end

  private
    def _id_from_name name
      @client.droplet.all.droplets.find { |droplet| droplet.name == name }
    end

end

Puppet::Type.type(:droplet).provide(:v2,
                                    parent: Puppet::Provider::Droplet) do
  confine feature: :barge
end

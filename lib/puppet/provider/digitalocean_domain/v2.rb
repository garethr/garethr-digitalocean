require 'barge'

Puppet::Type.type(:digitalocean_domain).provide(:v2) do
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
    client.domain.all.domains.collect do |domain|
      new(domain_to_hash(domain))
    end
  end

  def self.prefetch(resources)
    instances.each do |prov|
      if resource = resources[prov.name]
        resource.provider = prov
      end
    end
  end

  def self.domain_to_hash(domain)
    {
      name: domain.name,
      ttl: domain.ttl,
      zone_file: domain.zone_file,
      ensure: :present,
    }
  end

  def exists?
    Puppet.info("Checking if domain #{resource[:name]} exists")
    @property_hash[:ensure] == :present
  end

  def create
    response = @client.domain.create(
      name: resource[:name],
      ip_address: resource[:ip_address],
    )
    if response.success?
      Puppet.info("Created new domain called #{resource[:name]}")
      @property_hash[:ensure] = :present
    else
      fail 'Failed to create domain'
    end
  end

  def destroy
    Puppet.info("Destroying domain #{resource[:name]}")
    response = @client.domain.destroy(resource[:name])
    fail('Failed to destroy domain') unless response.success?
    @property_hash[:ensure] = :absent
  end

end

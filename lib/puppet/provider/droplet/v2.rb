require 'barge'
require 'base64'

require 'retries'
require 'puppet_x/garethr/digitalocean/prefetch_error'

class StillRunningError < Exception

end

Puppet::Type.type(:droplet).provide(:v2) do
  confine feature: :barge

  mk_resource_methods

  def self.read_only(*methods)
    methods.each do |method|
      define_method("#{method}=") do |v|
        fail "#{method} property is read-only once #{resource.type} created."
      end
    end
  end

  read_only(:image, :region)

  def initialize(*args)
    @client = self.class.client
    super(*args)
  end

  def self.client
    Barge::Client.new(access_token: ENV['DIGITALOCEAN_ACCESS_TOKEN'])
  end

  def self.instances
    begin
      client.droplet.all.droplets.collect do |droplet|
        new(droplet_to_hash(droplet))
      end
    rescue Timeout::Error, StandardError => e
      raise PuppetX::Garethr::DigitalOcean::PrefetchError.new(self.resource_type.name.to_s, e)
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
    config = {
      name: droplet.name,
      region: droplet.region.slug,
      size: droplet.size_slug,
      image: droplet.image.id,
      backups: droplet.features.include?('backups'),
      ipv6: droplet.features.include?('ipv6'),
      private_networking: droplet.features.include?('private_networking'),
      image_slug: droplet.image.slug,
      price_monthly: droplet['size'].price_monthly,
      ensure: :present,
    }

    private_addr = droplet.networks.v4.detect { |address| address.type == 'private' }
    public_addr = droplet.networks.v4.detect { |address| address.type == 'public' }
    config[:private_address] = private_addr.ip_address if private_addr
    config[:public_address] = public_addr.ip_address if public_addr

    public_addr_ipv6 = droplet.networks.v6.detect { |address| address.type == 'public' }
    config[:public_address_ipv6] = public_addr_ipv6.ip_address if public_addr_ipv6

    config
  end

  def exists?
    Puppet.info("Checking if droplet #{name} exists")
    @property_hash[:ensure] == :present
  end

  def create
    response = @client.droplet.create(
      name: name,
      region: resource[:region],
      size: resource[:size],
      image: resource[:image],
      user_data: resource[:user_data],
      ssh_keys: resource[:ssh_keys],
      backups: resource[:backups],
      ipv6: resource[:ipv6],
      private_networking: resource[:private_networking])
    if response.success?
      Puppet.info("Created new droplet called #{name}")
    else
      fail("Failed to create droplet #{name}: #{response.message}")
    end
  end

  def destroy
    Puppet.info("Destroying droplet #{name}")
    if droplet
      response = @client.droplet.destroy(droplet.id)
      fail("Failed to destroy droplet #{name}") unless response.success?
      @property_hash[:ensure] = :absent
    end
  end

  def ipv6=(value)
    if value.to_s == 'true'
      @client.droplet.enable_ipv6(droplet.id)
    else
      fail("Disabling IPv6 for #{name} is not supported")
    end
  end

  def size=(value)
    unless droplet.region.sizes.include? value
      fail("Size was '#{value}' and must be one of #{droplet.region.sizes.join(', ')}")
    end
    Puppet.info("Powering off droplet #{name}")
    @client.droplet.power_off(droplet.id)
    Puppet.info("Resizing droplet #{name}")
    handler = Proc.new do |exception, attempt_number, total_delay|
      Puppet.debug("#{exception.message}; retry attempt #{attempt_number}; #{total_delay} seconds have passed")
    end
    with_retries(:max_tries => 10,
      :base_sleep_seconds => 5,
      :max_sleep_seconds => 15,
      :handler => handler,
      :rescue => [StillRunningError]) do
        response = @client.droplet.resize(droplet.id, size: value)
        break if response.message == 'The droplet is already set to this size.'
        raise StillRunningError.new("Attempt to resize #{name}") unless response.success?
    end
    Puppet.info("Powering up droplet #{name}")
    with_retries(:max_tries => 10,
      :base_sleep_seconds => 5,
      :max_sleep_seconds => 15,
      :handler => handler,
      :rescue => [StillRunningError]) do
        response = @client.droplet.power_on(droplet.id)
        raise StillRunningError.new("Attempt to restart #{name}") unless response.success?
    end
  end

  def backups=(value)
    if value.to_s == 'true'
      fail("Enabling backups for #{name} is not supported")
    else
      @client.droplet.disable_backups(droplet.id)
    end
  end

  def private_networking=(value)
    if value.to_s == 'true'
      @client.droplet.enable_private_networking(droplet.id)
    else
      fail("Disabling private networking for #{name} is not supported")
    end
  end

  private
    def _droplet_from_name(name)
      @client.droplet.all.droplets.find { |droplet| droplet.name == name }
    end

    def droplet
      _droplet_from_name(name)
    end

end

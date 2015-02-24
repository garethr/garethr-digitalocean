$pe_master_hostname = 'puppet-master'
$pe_master_ip       = 'change-this-ip'
$pe_version_string = '3.7.2'

droplet { ['puppet-agent']:
  ensure             => present,
  region             => 'lon1',
  size               => '1gb',
  image              => 9801950, # Ubuntu 14.04.1 64bit LTS
  backups            => false,
  ipv6               => false,
  private_networking => false,
  user_data          => template('agent-pe-userdata.erb'),
}
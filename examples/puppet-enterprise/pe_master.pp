$pe_version_string = '3.7.2'
$pe_password = 'puppetlabs'

if versioncmp($pe_version_string, '3.7.0') >= 0 {
  # PE > 3.7 doesn't like email usernames
  $pe_username = 'admin'
}
else {
  $pe_username = 'admin@puppetlabs.com'
}

droplet { ['puppet-master']:
  ensure             => present,
  region             => 'lon1',
  size               => '8gb',
  image              => 9801950, # Ubuntu 14.04.1 64bit LTS
  backups            => false,
  ipv6               => false,
  private_networking => false,
  user_data          => template('master-pe-userdata.erb'),
}
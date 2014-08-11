Puppet module for managing droplets on
[DigitalOcean](https://www.digitalocean.com/?refcode=69ef0beac642).

Under the hood this module uses [Barge](https://github.com/boats/barge)
and the [V2 API](https://developers.digitalocean.com/v2). This module is also available on the [Puppet
Forge](https://forge.puppetlabs.com/garethr/digitalocean).

[![Build
Status](https://secure.travis-ci.org/garethr/garethr-digitalocean.png)](http://travis-ci.org/garethr/garethr-digitalocean)

## Usage

The module includes a single type and provider which can be used to
create droplets.

```puppet
droplet { ['test-digitalocean', 'test-digitalocean-1']:
  ensure => present,
  region => 'lon1',
  size   => '512mb',
  image  => 5141286,
}
```

Note that for this to work you will need an access token for the V2 API
and to put that in an environment variable like so:

```bash
export DIGITALOCEAN_ACCESS_TOKEN=yourtokenhere
```

## Limitations

Currently the module only exposes `region`, `size`, `image` and `name`
and only manages the `droplet` resource.

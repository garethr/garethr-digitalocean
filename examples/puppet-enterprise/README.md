# Puppet Enterprise

[Puppet Enterprise](http://puppetlabs.com/puppet/puppet-enterprise) is free for up to 10 nodes,
and a great way of getting started with Puppet. This example brings up a Puppet Master and one agent.

## What

```
                                      443
                                       +
                                       |
                                       |
                   +-------------------|-------------------+
                   |          +--------v--------+          |
                   |          |                 |          |
                   |          |  puppet-master  |          |
                   |          |                 |          |
 puppet-enterprise |          +-----------------+          |
                   |          +-----------------+          |
                   |          |                 |          |
                   |          |  puppet-agent   |          |
                   |          |                 |          |
                   |          +-----------------+          |
                   +---------------------------------------+

```


## How

This example is in two parts, first we'll bring up the Puppet Master. And after
making a quick configuration change we'll bring up the Puppet agents.

With the module installed as described in the README, from this
directory run:

    puppet apply pe_master.pp --test --templatedir templates

This will bring up the master. Please note that this could take up to 10
minutes.

We now need to modify the `pe_agent.pp` manifest so it points at the newly created
master. Open your DigitalOcean portal, get the IP for the master, then open up `pe_agent.pp` and change the line:

    $pe_master_ip       = 'change-this-ip'

Alternatively you can use the Puppet resource commands:

    $ puppet resource droplet puppet-master

This should return a Puppet resource, including the public_address:

```puppet
droplet { 'puppet-master':
  ensure         => 'present',
  image          => '9801950',
  public_address => '171.62.19.42',
  region         => 'lon1',
}
```

Finally you can run:

    puppet apply pe_agent.pp --test --templatedir templates

Now lets login to your new Puppet Enterprise console. Retrieve the public_address address
of the `puppet-master` instance from the DigitalOcean console or using `puppet resource`, then visit:

    https://your-masters-ip-address

You can login with the username `admin` and the password `puppetlabs`,
or you can change these in the `pe_agent.pp` file mentioned above.

Note the https part: Because we're just using a temporary IP address here you'll likely
get a certificate error from your browser, ignore this for now.

You can learn more about using Puppet Enterprise from the comprehensive
[user guide](https://docs.puppetlabs.com/pe/latest/)

# Caveats

This example is a good Proof of Concept of how to setup Puppet Enterprise inside DigitalOcean, but has a few rough edges, specifically:

* The use of cloud-init to bootstrap masters and agents is limited to certain images:

> CloudInit is currently available on DigitalOcean's latest CoreOS, Ubuntu 14.04, and CentOS 7 images.

[Taken from An Introduction to Droplet Metadata, 24/02/2015](https://www.digitalocean.com/community/tutorials/an-introduction-to-droplet-metadata)

* You need to run the manifests seperately, and manually change the IP for the master before running the agent code
* All certificates from agents are automatically signed by the master

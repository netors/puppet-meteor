# == Class: meteor
#
# Full description of class meteor here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'meteor':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2015 Your name here, unless otherwise noted.
#
class meteor (
  $version = "1.0.3.2", # Default version to use
  $meteorpassword = "meteor",
  $meteorusername = "meteor",
) {

## Pick the right architecture
  if $kernel == "Linux"{
    if $architecture == "x86"{
      $platform = "os.linux.x86_32"
    } else {
      $platform = "os.linux.x86_64"
    }
  }
## Create the meteor user
  user { $meteorusername:
    password   => $meteorpassword,
    managehome => true
  }

## Keep meteor source on the system.. it's small...
## And including wget - make sure maestrodev/wget installed
  include wget
  wget::fetch { "get_meteor_bootstrap":
    source      => "https://d3sqy0vbqsdhku.cloudfront.net/packages-bootstrap/${version}/meteor-bootstrap-${platform}.tar.gz",
    destination => "/usr/share/meteor-${version}.tar.gz",
    timeout     => 0,
    verbose     => false,
  }

## Extract meteor into the right environment

  exec { "extract_meteor":
    command  => "/bin/tar zxf /usr/share/meteor-${version}.tar.gz -C /home/${meteorusername}",
    creates  => "/home/${meteorusername}/.meteor",
    require  => [Wget::Fetch['get_meteor_bootstrap'],User[$meteorusername]]
  }
  exec { "chown_meteor":
    command => "/bin/chown -R ${meteorusername}.${meteorusername} /home/${meteorusername}",
    require => Exec['extract_meteor']
  }
  file { "/usr/bin/meteor":
    ensure => link,
    mode   => "0777",
    target => "/home/meteor/.meteor/packages/meteor-tool/1.0.41/meteor-tool-${platform}/scripts/admin/launch-meteor"
  }
}

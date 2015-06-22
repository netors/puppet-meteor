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
# Copyright 2015 Vormetric Inc.
#
class meteor (

) {


## Keep meteor source on the system.. it's small...
## And including wget - make sure maestrodev/wget installed

  package { "curl":
    ensure => "present"
  }->
  exec { "download meteor installer":
    command => "/usr/bin/curl https://install.meteor.com --output /usr/share/install_meteor.sh",
    creates => "/usr/share/install_meteor.sh"
  }->
  exec { "install meteor":
    command => "/bin/bash /usr/share/install_meteor.sh",
    user    => "root",
  }
}

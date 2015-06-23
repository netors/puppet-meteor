class meteor::install (
  $install_mongo = $meteor::params::install_mongo,
  $mongo_port = $meteor::params::mongo_port
) inherits meteor::params
{

### First lets make sure we got CURL
  package { "curl":
    ensure => "present"
  }->
  class { "nodejs": }->
  package { "pm2":
    provider => npm,
    ensure   => present
  }->
  ### Second download latest installer script
  exec { "download meteor installer":
    command => "/usr/bin/curl https://install.meteor.com --output /usr/share/install_meteor.sh",
    creates => "/usr/share/install_meteor.sh"
  }->

  ### make sure it's owned by root and executable
  file { "/usr/share/install_meteor.sh":
    ensure => present,
    mode   => 755,
    owner  => "root",
    group  => "root"
  }->

  ### execute installer script
  exec { "install meteor":
    command     => "/bin/bash /usr/share/install_meteor.sh",
    user        => "root",
    environment => "HOME=/root",
    creates     => "/root/.meteor"
  }

### Install MongoDB for those production instances...
  if $install_mongo {
    class { '::mongodb::server':
      port    => $mongo_port,
      verbose => false,
    }->
    class { 'nginx':
      proxy_http_version => "1.1",

    }
  }

}
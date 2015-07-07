class meteor::app (
  $app_dir = undef, # Where the bundled vesion will go
  $app_name = undef,
  $app_source_dir = "/tmp",
  $app_port = "3000",
  $source = undef,
  $from_source = false,
  $example_app = $meteor::params::example_app,
  $mongo_port = $meteor::params::mongo_port,
  $mongo_url = undef,
  $vcsrepo_provider = "git",
  $vcsrepo_rev = "master",
  $vcsrepo_ensure = latest,
  $user = $meteor::user ,
  $app_root_url = "http://localhost",
  $app_vhost_name = undef,

) inherits meteor {

### generate local mongodb connection if needed... else take the overriden mongodb url
  if !$mongo_url {
    $my_mongo_url = "mongodb://127.0.0.1:${mongo_port}/${app_name}"
  } else {
    $my_mongo_url = $mongo_url
  }



  if !$app_dir {
    fail("app_dir is required for successful app installation")
  } else {


  ## Install the meteor app
    if $user == "root" {
      $user_home = "/root"
    } else {
      $user_home = "/home/${user}"
    }

  ### checkout/convert/copy the Meteor bundled app to $app_dir
    if $from_source {
      if !$source {
        fail ("you need to add the source here...")
      } else {
      ## if using source, we are going to assume git...
        package { $vcsrepo_provider: }->
        vcsrepo { $app_source_dir:
          ensure   => $vcsrepo_ensure,
          revision => $vcsrepo_rev,
          provider => $vcsrepo_provider,
          source   => $source,
          user     => $user
        }->
        exec { "convert app to bundle":
          command     => "/usr/local/bin/meteor build ${app_dir} --directory --server=${app_root_url}",
          cwd         => $app_source_dir,
          environment => ["HOME=${user_home}","USER=${user}"],
          user        => $user,
          creates     => "${app_dir}/bundle/main.js",
          subscribe   => Vcsrepo[$app_source_dir],
          refreshonly => true
        }
      }
    } else {
      exec { "convert app to bundle":
        command     => "/usr/local/bin/meteor build ${app_dir} --directory",
        cwd         => $app_source_dir,
        environment => ["HOME=${user_home}","USER=${user}"],
        user        => $user,
        creates     => "${app_dir}/bundle/main.js"
      }
    }

  ### Use Node.JS to install the dependencies...

    Exec["convert app to bundle"]->
    exec{ "update npm":
      command     => "/usr/bin/npm install",
      cwd         => "${app_dir}/bundle/programs/server",
      creates     => "${app_dir}/bundle/programs/node_modules",

    }->
    file { "${app_dir}/bundle/processes.json":
      ensure  => present,
      content => template("meteor/app.json.erb"),
      owner   => $user,
    }->
    ## Install pm2 startup service if needed
    exec { "install pm2 service":
      command     => "/usr/bin/pm2 startup -u ${user}",
      environment => ["HOME=${user_home}","USER=${user}"],
      creates     => "/etc/init.d/pm2-init.sh",
    }->
    file { "${user_home}/.pm2":
      owner  => $user,
      ensure => directory,
      group => $user,
      recurse => false,
      purge => false
    }->
    exec { "install app to pm2":
      command     => "/usr/bin/pm2 start ${app_dir}/bundle/processes.json --name ${app_name}",
      cwd         => "${app_dir}/bundle",
      user        => $user,
      environment => ["HOME=${user_home}","USER=${user}","METEOR_SETTINGS=${app_dir}/bundle/settings.json"],
      unless      => "/usr/bin/pm2 -m list | grep '--- ${app_name}'",
    }
  }

### setup nginx reverse proxy vhost
  if $app_vhost_name{

    nginx::resource::upstream { "${app_name}_proxy":
      members => [
        "localhost:${app_port}",
      ],
    }->
    file { "/etc/nginx/conf.d/http_upgrade-map.conf":
      ensure => present,
      source => "puppet:///modules/meteor/http_upgrade.conf",
      mode   => "755",
      owner  => "www-data"
    }->
    nginx::resource::vhost { $app_vhost_name:
      proxy            => "http://${app_name}_proxy",
      proxy_set_header => ['Upgrade $http_upgrade','Connection $connection_upgrade','X-Forwarded-For $remote_addr'],
    }
  }
}
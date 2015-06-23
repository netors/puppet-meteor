# meteor

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with meteor](#setup)
    * [What meteor affects](#what-meteor-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with meteor](#beginning-with-meteor)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

Installs [Meteor](http://www.meteor.com) onto Linux systems...

## Module Description

Meteor is a new and exciting full stack javascript platform, that simplifies and shortcuts development efforts, yet it's
a bit confusing on how to create a real production instance of the service.  This puppet module aims to solve that problem.

It's designed to install meteor for the system, and selected user (root by default).  Also it can be used to install 
MongoDB, Nginx, and PM2 for a production environment.  It's currently HTTP only via a reverse proxy.

Installing meteor apps requires the orginal source files, and it then "builds" them into native node.js applications for 
hosting in PM2, with a nginx proxy.  


## Setup

### What meteor affects

* Installs meteor systemwide
* Can be used to host production versions of a meteor app


### Beginning with meteor

Simply install the module to your puppet module path

```ruby
puppet module install vormetriclabs-meteor
```

or in Puppetfile/r10k/librarian-puppet

```ruby
mod "vormetriclabs-meteor"
```

## Usage

Just install it as root
```ruby
include meteor
```

Installs it as a non-root user
```ruby
class {"meteor":
    user => "meteor"
}
```


## Reference

To use it as a class...
```ruby
class {"meteor":

}
```

Host a meteor application
```ruby
class {"meteor":}->
class { "meteor::app":
  app_name       => "simple-todos", # Application Name
  app_dir        => "/tmp/app_dir",  # Where the application bundle will be deployed/hosted
  app_root_url   => "http://simple-todos", # Actual URL for the application
  app_vhost_name => "simple-todos",  # Host name for nginx vhost setting
  from_source    => true,  # your application source is hosted in a git repo or not...
  source         => "https://github.com/meteor/simple-todos.git",  # URL to checkout your application source
  app_source_dir => "/home/vagrant/simple-todos",  # temp directory to check out too, or where you put the application source.
}
```


## Limitations

Only tested on Ubuntu 12.04 and 14.04 32/64bits, but should work on any 32/64 bit Linux

## Development

There is a Vagrantfile present to test out the module.  Just "vagrant up" and it should build and install meteor on the guest OS.  However there are 2 prereqs to "vagrant up" successfully.

- You'll need to install vagrant-librarian-puppet to your vagrant installation - https://github.com/mhahn/vagrant-librarian-puppet
- You'll need to create an empty folder in the project folder called "modules"  it's a silly bug, that we'll get to someday :)

It does require [vagrant-librarian-puppet](https://github.com/mhahn/vagrant-librarian-puppet), if you are using Windows
you may need to use our fork until the Pull Request to fix the facter issue is merged.  [vormetriclabs/vagrant-librarian-puppet](https://github.com/vormetriclabs/vagrant-librarian-puppet)

## Release Notes/Contributors/Etc **Optional**

Feel free to contribute or submit Pull Requests

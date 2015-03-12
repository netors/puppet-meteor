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

It's designed to install meteor into a dedicated user account named "meteor", and then make it globally available via a
symlink to the rest of the users(current design requirement of meteor), and when they run meteor for the first time, it
will install a copy of meteor to their home directory(~/.meteor).  Then depending on Dev or Prod environment setting,
install the supporting services/packages/configurations to allow development, or servicing of your meteor apps.

Meteor apps are designed to run either completely by themselves, or via


## Setup

### What meteor affects

* Creates a user named meteor to own the system meteor installation
* Downloads the desired meteor version to /usr/share/meteor.tar.gz
* Extracts meteor to /home/$meteorusername/.meteor
* Creates symlink of /usr/bin/meteor to /home/meteor/.meteor/packages/meteor-tool/1.0.41/meteor-tool-${platform}/scripts/admin/launch-meteor
* Then one can simply run /usr/bin/meteor and meteor will auto install the distribution to your home dir ( ~/.meteor )

### Setup Requirements **OPTIONAL**

Depends on maestrodev/wget for downloading the meteor installer.

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

Just install it...
```ruby
include meteor
```



## Reference

To override version change the version parameter.
```ruby
class {"meteor":
   version =>  "1.0.3.2"
}
```


## Limitations

Only tested on Ubuntu 12.04 and 14.04 32/64bits, but should work on any 32/64 bit Linux

## Development

There is a Vagrantfile present to test out the module.  Just "vagrant up" and it should build and install meteor on the guest OS.

It does require [vagrant-librarian-puppet](https://github.com/mhahn/vagrant-librarian-puppet), if you are using Windows
you may need to use our fork until the Pull Request to fix the facter issue is merged.  [vormetriclabs/vagrant-librarian-puppet](https://github.com/vormetriclabs/vagrant-librarian-puppet)

## Release Notes/Contributors/Etc **Optional**

Feel free to contribute or submit Pull Requests

# The baseline for module testing used by Puppet Labs is that each manifest
# should have a corresponding test manifest that declares that class or defined
# type.
#
# Tests are then run by using puppet apply --noop (to check for compilation
# errors and view a log of events) or by fully applying the test in a virtual
# environment (to compare the resulting system state to the desired state).
#
# Learn more about module testing here:
# http://docs.puppetlabs.com/guides/tests_smoke.html
#
class { "meteor":
  install_mongo => true,
  user          => "vagrant"
}
class { "meteor::app":
  app_name       => "simple-todos",
  app_dir        => "/tmp/app_dir",
  app_root_url   => "http://simple-todos",
  app_vhost_name => "simple-todos",
  from_source    => true,
  source         => "https://github.com/meteor/simple-todos.git",
  app_source_dir => "/home/vagrant/simple-todos",
}





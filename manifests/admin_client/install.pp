# private class
class pulp::admin_client::install {

  package { 'pulp-admin-client':
    ensure  => $pulp::admin_client::package_ensure,
  }

  package { 'pulp-puppet-admin-extensions':
    ensure  => $pulp::admin_client::package_ensure,
  }

  package { 'pulp-rpm-admin-extensions':
    ensure => $pulp::admin_client::package_ensure,
  }

}

# private class
class pulp::server::install {

  package { 'qpid-tools':
    ensure  => $pulp::server::package_ensure,
  }

  package { 'qpid-cpp-server':
    ensure  => $pulp::server::package_ensure,
  }

  package { 'qpid-cpp-server-linearstore':
    ensure  => $pulp::server::package_ensure,
  }

  package { 'pulp-server':
    ensure => $pulp::server::package_ensure,
  }

  package { 'pulp-puppet-plugins':
    ensure => $pulp::server::package_ensure,
  }

  package { 'pulp-rpm-plugins':
    ensure => $pulp::server::package_ensure,
  }

  package { 'pulp-selinux':
    ensure => $pulp::server::package_ensure,
  }

  package { 'python-qpid':
    ensure => $pulp::server::package_ensure,
  }

  package { 'python-qpid-qmf':
    ensure => $pulp::server::package_ensure,
  }

}

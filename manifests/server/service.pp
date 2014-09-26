# private class
class pulp::server::service {

  service { 'qpidd':
    ensure      => $pulp::server::service_ensure,
    enable      => $pulp::server::service_enable,
    hasrestart  => true,
    before      => Service['httpd'],
  }

  if $pulp::server::manage_apache {
    service { 'httpd':
      ensure      => $pulp::server::service_ensure,
      enable      => $pulp::server::service_enable,
      hasrestart  => true,
    }
  }

  service { 'pulp_workers':
    ensure      => $pulp::server::service_ensure,
    enable      => $pulp::server::service_enable,
    hasrestart  => true,
    require     => Service['httpd']
  }->
  service { 'pulp_celerybeat':
    ensure      => $pulp::server::service_ensure,
    enable      => $pulp::server::service_enable,
    hasrestart  => true,
  }->
  service { 'pulp_resource_manager':
    ensure      => $pulp::server::service_ensure,
    enable      => $pulp::server::service_enable,
    hasrestart  => true,
  }

}

# private class
class pulp::admin_client::config {

  $verify_ssl = $pulp::admin_client::verify_ssl ? {
    true  => 'True',
    false => 'False',
  }

  file { '/etc/pulp/admin/admin.conf':
    ensure => $pulp::admin_client::file_ensure,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  Pulp_admin_config {
    ensure  => $pulp::admin_client::ensure,
  }

  pulp_admin_config { 'server/host': value => $pulp::admin_client::server }
  pulp_admin_config { 'server/verify_ssl': value => $verify_ssl }
  pulp_admin_config { 'server/ca_path': value => $pulp::admin_client::ca_path }


}

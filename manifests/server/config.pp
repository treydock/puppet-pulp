# private class
class pulp::server::config {

  $oauth_enabled = $pulp::server::oauth_enabled ? {
    true  => 'true',
    false => 'false',
  }

  $pulp_manage_db_require = [
    Pulp_server_config['database/name'],
    Pulp_server_config['database/seeds'],
    Pulp_server_config['database/username'],
    Pulp_server_config['database/password'],
  ]

  file { '/etc/pulp/server.conf':
    ensure => $pulp::server::file_ensure,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  Pulp_server_config {
    ensure  => $pulp::server::ensure,
    notify  => Service['httpd'],
  }

  pulp_server_config { 'database/name': value => $pulp::server::database_name }
  pulp_server_config { 'database/seeds': value => "${pulp::server::mongodb_server}:${pulp::server::mongodb_port}" }
  if $pulp::server::database_username {
    pulp_server_config { 'database/username': value => $pulp::server::database_username }
  }
  if $pulp::server::database_password {
    pulp_server_config { 'database/password': value => $pulp::server::database_password }
  }

  pulp_server_config { 'oauth/enabled': value => $oauth_enabled }
  if $pulp::server::oauth_key {
    pulp_server_config { 'oauth/oauth_key': value => $pulp::server::oauth_key }
  }
  if $pulp::server::oauth_secret {
    pulp_server_config { 'oauth/oauth_secret': value => $pulp::server::oauth_secret }
  }

  if $pulp::server::ensure == 'present' {
    file_line { 'qpidd auth':
      path    => '/etc/qpid/qpidd.conf',
      line    => 'auth=no',
      notify  => Service['qpidd'],
    }
  }

  # The mongod service script doesn't block, so we'll keep trying
  # this for up to two minutes
  exec { 'pulp-manage-db':
    path        => '/usr/bin:/bin:/usr/sbin:/sbin',
    command     => 'pulp-manage-db && touch /var/lib/pulp/.puppet-pulp-manage-db',
    tries       => 12,
    try_sleep   => 10,
    user        => 'apache',
    unless      => 'test -f /var/lib/pulp/.puppet-pulp-manage-db',
    require     => $pulp_manage_db_require,
  }

}

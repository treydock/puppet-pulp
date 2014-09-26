# private class
class pulp::server::config {

  file { '/etc/pulp/server.conf':
    ensure  => $pulp::server::file_ensure,
    owner   => 'root',
    group   => 'apache',
    mode    => '0640',
    content => template('pulp/server.conf.erb'),
  }

#  Pulp_server_config {
#    ensure  => $pulp::server::ensure,
#    notify  => Service['httpd'],
#    before  => Exec['pulp-manage-db'],
#  }

#  pulp_server_config { 'database/name': value => $pulp::server::database_name }
#  pulp_server_config { 'database/seeds': value => "${pulp::server::database_server}:${pulp::server::database_port}" }
#  if $pulp::server::database_username {
#    pulp_server_config { 'database/username': value => $pulp::server::database_username }
#  }
#  if $pulp::server::database_password {
#    pulp_server_config { 'database/password': value => $pulp::server::database_password }
#  }

  if $pulp::server::ensure == 'present' {
    file_line { 'qpidd auth':
      path   => '/etc/qpid/qpidd.conf',
      line   => 'auth=no',
      notify => Service['qpidd'],
    }
  }

  # The mongod service script doesn't block, so we'll keep trying
  # this for up to two minutes
  exec { 'pulp-manage-db':
    path      => '/usr/bin:/bin:/usr/sbin:/sbin',
    command   => 'pulp-manage-db && touch /var/lib/pulp/.puppet-pulp-manage-db',
    tries     => 12,
    try_sleep => 10,
    user      => 'apache',
    unless    => 'test -f /var/lib/pulp/.puppet-pulp-manage-db',
  }

}

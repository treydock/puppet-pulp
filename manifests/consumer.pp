# installs the pulp::consumer client
class pulp::consumer(
  $ensure = 'present',
  $server = $::fqdn) {

  package { [ 'pulp-agent',
              'pulp-consumer-client',
              'pulp-puppet-consumer-extensions',
              'pulp-puppet-handlers',
              'pulp-rpm-consumer-extensions',
              'pulp-rpm-handlers',
              'pulp-rpm-yumplugins' ]:
    ensure => $ensure
  }

  # For the template
  $pulp_server = $server

  Package['pulp-consumer-client'] -> Pulp_consumer_config<| |> -> File['/etc/pulp/consumer/consumer.conf']
  Pulp_consumer_config<| |> ~> Service['pulp-agent']

  if $ensure == 'absent' {
    file { '/etc/pulp/consumer/consumer.conf':
      ensure  => 'absent',
    }

    service { 'pulp-agent':
      ensure => 'stopped',
      before => Package['pulp-agent']
    }
  } else {
    file { '/etc/pulp/consumer/consumer.conf':
      ensure  => 'present',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }

    pulp_consumer_config { 'server/host': value => $pulp_server }

    service { 'pulp-agent':
      ensure  => 'running',
      require => Package['pulp-agent']
    }
  }
}

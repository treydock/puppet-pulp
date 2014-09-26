# installs the pulp server
class pulp::server(
  $ensure = 'present',
  $manage_apache = true,
  $manage_mongodb = true,
  $database_name  = 'pulp_database',
  $mongodb_server = 'localhost',
  $mongodb_port = '27017',
  $database_username = undef,
  $database_password = undef,
  $oauth_enabled = false,
  $oauth_key  = undef,
  $oauth_secret = undef,
) {

  validate_bool($manage_apache)
  validate_bool($manage_mongodb)
  validate_bool($oauth_enabled)

  case $ensure {
    'present': {
      $directory_ensure = 'directory'
      $file_ensure      = 'file'
      $package_ensure   = 'present'
      $service_ensure   = 'running'
      $service_enable   = true
    }
    'absent': {
      $directory_ensure = 'absent'
      $file_ensure      = 'absent'
      $package_ensure   = 'absent'
      $service_ensure   = 'stopped'
      $service_enable   = false
    }
    default: {
      fail("Module ${module_name}: ensure parameter must be 'present' or 'absent', ${ensure} given.")
    }
  }

  anchor { 'pulp::server::start': }
  anchor { 'pulp::server::end': }

  include pulp::server::install
  include pulp::server::config
  include pulp::server::service

  if $manage_mongodb {
    include ::mongodb::server

    Anchor['pulp::server::start']->
    Class['::mongodb::server']->
    Class['pulp::server::install']->
    Class['pulp::server::config']->
    Class['pulp::server::service']->
    Anchor['pulp::server::end']
  } else {
    Anchor['pulp::server::start']->
    Class['pulp::server::install']->
    Class['pulp::server::config']->
    Class['pulp::server::service']->
    Anchor['pulp::server::end']
  }

}

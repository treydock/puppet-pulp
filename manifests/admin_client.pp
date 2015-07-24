# Installs the admin client
class pulp::admin_client (
  $ensure = 'present',
  $package_ensure = undef,
  $server = $::fqdn,
  $verify_ssl = true,
  $ca_path = '/etc/pki/tls/certs/ca-bundle.crt',
) {

  case $ensure {
    'present': {
      $file_ensure      = 'file'
      $_package_ensure  = pick($package_ensure, 'present')
    }
    'absent': {
      $file_ensure      = 'absent'
      $_package_ensure  = 'absent'
    }
    default: {
      fail("Module ${module_name}: ensure parameter must be 'present' or 'absent', ${ensure} given.")
    }
  }

  anchor { 'pulp::admin_client::start': }
  anchor { 'pulp::admin_client::end': }

  include pulp::admin_client::install
  include pulp::admin_client::config

  Anchor['pulp::admin_client::start']->
  Class['pulp::admin_client::install']->
  Class['pulp::admin_client::config']->
  Anchor['pulp::admin_client::end']

}

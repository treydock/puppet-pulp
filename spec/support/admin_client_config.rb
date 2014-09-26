shared_examples_for 'pulp::admin_client::config' do
  it do
    should contain_file('/etc/pulp/admin/admin.conf').with({
      :ensure  => 'file',
      :owner   => 'root',
      :group   => 'root',
      :mode    => '0644',
    })
  end

  it do
    should contain_pulp_server_config('server/host').with({
      :ensure => 'present',
      :value  => facts[:fqdn],
    })
  end

  it do
    should contain_pulp_server_config('server/verify_ssl').with({
      :ensure => 'present',
      :value  => 'True',
    })
  end

  it do
    should contain_pulp_server_config('server/ca_path').with({
      :ensure => 'present',
      :value  => '/etc/pki/tls/certs/ca-bundle.crt',
    })
  end

end

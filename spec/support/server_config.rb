shared_examples_for 'pulp::server::config' do
  it do
    should contain_file('/etc/pulp/server.conf').with({
      :ensure  => 'file',
      :owner   => 'root',
      :group   => 'root',
      :mode    => '0644',
    })
  end

  it do
    should contain_pulp_server_config('database/name').with({
      :ensure => 'present',
      :notify => 'Service[httpd]',
      :value  => 'pulp_database',
      :before => 'Exec[pulp-manage-db]',
    })
  end

  it do
    should contain_pulp_server_config('database/seeds').with({
      :ensure => 'present',
      :notify => 'Service[httpd]',
      :value  => 'localhost:27017',
      :before => 'Exec[pulp-manage-db]',
    })
  end

  it { should_not contain_pulp_server_config('database/username') }
  it { should_not contain_pulp_server_config('database/password') }

  it do
    should contain_pulp_server_config('oauth/enabled').with({
      :ensure => 'present',
      :notify => 'Service[httpd]',
      :value  => 'false',
      :before => 'Exec[pulp-manage-db]',
    })
  end

  it { should_not contain_pulp_server_config('oauth/oauth_key') }
  it { should_not contain_pulp_server_config('oauth/oauth_secret') }

  it do
    should contain_file_line('qpidd auth').with({
      :path   => '/etc/qpid/qpidd.conf',
      :line   => 'auth=no',
      :notify => 'Service[qpidd]',
    })
  end

  it do
    should contain_exec('pulp-manage-db').with({
      :path        => '/usr/bin:/bin:/usr/sbin:/sbin',
      :command     => 'pulp-manage-db && touch /var/lib/pulp/.puppet-pulp-manage-db',
      :tries       => '12',
      :try_sleep   => '10',
      :user        => 'apache',
      :unless      => 'test -f /var/lib/pulp/.puppet-pulp-manage-db',
    })
  end
end

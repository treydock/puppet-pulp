shared_examples_for 'pulp::server::config' do
=begin
  it do
    should contain_file('/etc/pulp/server.conf').with({
      :ensure  => 'file',
      :owner   => 'root',
      :group   => 'apache',
      :mode    => '0640',
    })
  end

  it do
    verify_contents(catalogue, '/etc/pulp/server.conf', [
      '[database]',
      'name: pulp_database',
      'seeds: localhost:27017',
      '[server]',
      '[authentication]',
      '[security]',
      '[consumer_history]',
      '[data_reaping]',
      '[oauth]',
      '[messaging]',
      '[tasks]',
      '[email]',
    ])
  end
=end

  [
    {:name => 'database/name', :value => 'pulp_database'},
    {:name => 'database/seeds', :value => 'localhost:27017'},
  ].each do |config|
    it do
      should contain_pulp_server_config(config[:name]).with({
        :ensure => 'present',
        :notify => 'Class[Pulp::Server::Service]',
        :value  => config[:value],
        :before => 'Exec[pulp-manage-db]',
      })
    end
  end

  [
    'database/username',
    'database/password',
    'database/replica_set',
  ].each do |config|
    it { should_not contain_pulp_server_config(config) }
  end

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

  context 'when database username and password defined' do
    let(:params) {{ :database_username => 'foo', :database_password => 'bar' }}

=begin
    it do
      verify_contents(catalogue, '/etc/pulp/server.conf', [
        '[database]',
        'name: pulp_database',
        'seeds: localhost:27017',
        'username: foo',
        'user: foo',
        'password: bar',
        '[server]',
        '[authentication]',
        '[security]',
        '[consumer_history]',
        '[data_reaping]',
        '[oauth]',
        '[messaging]',
        '[tasks]',
        '[email]',
      ])
    end
=end

    [
      {:name => 'database/username', :value => 'foo'},
      {:name => 'database/password', :value => 'bar'},
    ].each do |config|
      it do
        should contain_pulp_server_config(config[:name]).with({
          :ensure => 'present',
          :notify => 'Class[Pulp::Server::Service]',
          :value  => config[:value],
          :before => 'Exec[pulp-manage-db]',
        })
      end
    end
  end

  context 'when database_seeds defined as a string' do
    let(:params) {{ :database_seeds => 'db01:27017,db02:27017' }}

    it do
      should contain_pulp_server_config('database/seeds').with_value('db01:27017,db02:27017')
    end
  end

  context 'when database_seeds defined as an array' do
    let(:params) {{ :database_seeds => ['db01:27017', 'db02:27017'] }}

    it do
      should contain_pulp_server_config('database/seeds').with_value('db01:27017,db02:27017')
    end
  end

  context 'when database_replica_set defined' do
    let(:params) {{ :database_replica_set => 'rsmain' }}

    it do
      should contain_pulp_server_config('database/replica_set').with({
        :ensure => 'present',
        :notify => 'Class[Pulp::Server::Service]',
        :value  => 'rsmain',
        :before => 'Exec[pulp-manage-db]',
      })
    end
  end
end

shared_examples_for 'pulp::server::service' do
  it do
    should contain_service('qpidd').with({
      :ensure     => 'running',
      :enable     => 'true',
      :hasrestart => 'true',
    }) \
    .that_comes_before('Service[httpd]')
  end

  it do
    should contain_service('httpd').with({
      :ensure     => 'running',
      :enable     => 'true',
      :hasrestart => 'true',
    })
  end

  it do
    should contain_service('pulp_workers').with({
      :ensure     => 'running',
      :enable     => 'true',
      :hasrestart => 'true',
    }) \
    .that_comes_before('Service[pulp_celerybeat]') \
    .that_requires('Service[httpd]')
  end

  it do
    should contain_service('pulp_celerybeat').with({
      :ensure     => 'running',
      :enable     => 'true',
      :hasrestart => 'true',
    }) \
    .that_comes_before('Service[pulp_resource_manager]')
  end

  it do
    should contain_service('pulp_resource_manager').with({
      :ensure     => 'running',
      :enable     => 'true',
      :hasrestart => 'true',
    })
  end
end

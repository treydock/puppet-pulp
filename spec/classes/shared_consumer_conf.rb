require 'spec_helper'

shared_context :consumer_conf_present do
  it do
    should contain_file('/etc/pulp/consumer/consumer.conf').with({
      :ensure  => 'present',
      :owner   => 'root',
      :group   => 'root',
      :mode    => '0644',
    })
  end
end


shared_context :consumer_conf_absent do
  it do
    should contain_file('/etc/pulp/consumer/consumer.conf').with_ensure 'absent'
  end
end

shared_context :consumer_config_present do
  it do
    should contain_pulp_consumer_config('server/host').with_value server
  end
end

shared_context :consumer_config_absent do
  it do
    should_not contain_pulp_consumer_config('server/host')
  end
end

require 'spec_helper'
require 'classes/shared_consumer_packages'
require 'classes/shared_consumer_conf'
require 'classes/shared_consumer_services'

describe 'pulp::consumer' do
  let(:server) { 'server.myhost.com' }
  let(:facts) { { :fqdn => server } }

  it { should_not be_nil }

  context 'with default parameters' do
    include_context :consumer_packages_present
    include_context :consumer_conf_present
    include_context :consumer_config_present
    include_context :consumer_services_running
  end

  context 'ensure => present' do
    let(:params) { { :ensure => 'present' } }
    include_context :consumer_packages_present
    include_context :consumer_conf_present
    include_context :consumer_config_present
    include_context :consumer_services_running
  end

  context 'ensure => 2.2.0-1.el6' do
    let(:version) { '2.2.0-1.el6' }
    let(:params) { { :ensure => version } }

    include_context :consumer_packages_pinned
    include_context :consumer_conf_present
    include_context :consumer_config_present
    include_context :consumer_services_running
  end

  context 'server => otherbox.myhost.com' do
    let(:params) { { :server => 'otherbox.myhost.com' } }
    let(:server) { 'otherbox.myhost.com' }

    include_context :consumer_config_present
  end

  context 'ensure => absent' do
    let(:params) { { :ensure => 'absent' } }

    include_context :consumer_packages_absent
    include_context :consumer_config_absent
    include_context :consumer_services_stopped
  end
end

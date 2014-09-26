require 'spec_helper'

describe 'pulp::admin_client' do

  let(:fqdn) { 'fqdn.myhost.com' }
  let(:facts) do 
    {
      :fqdn     => fqdn,
      :osfamily => 'RedHat',
    }
  end

  it { should create_class('pulp::admin_client') }

  it { should contain_anchor('pulp::admin_client::start').that_comes_before('Class[pulp::admin_client::install]') }
  it { should contain_class('pulp::admin_client::install').that_comes_before('Class[pulp::admin_client::config]') }
  it { should contain_class('pulp::admin_client::config').that_comes_before('Anchor[pulp::admin_client::end]') }
  it { should contain_anchor('pulp::admin_client::end') }

  it_behaves_like 'pulp::admin_client::install'
  it_behaves_like 'pulp::admin_client::config'

end

require 'spec_helper'

describe 'pulp::server' do

  let(:fqdn) { 'fqdn.myhost.com' }
  let(:facts) do 
    {
      :fqdn     => fqdn,
      :osfamily => 'RedHat',
    }
  end

  it { should contain_anchor('pulp::server::start').that_comes_before('Class[mongodb::server]') }
  it { should contain_class('mongodb::server').that_comes_before('Class[pulp::server::install]') }
  it { should contain_class('pulp::server::install').that_comes_before('Class[pulp::server::config]') }
  it { should contain_class('pulp::server::config').that_comes_before('Class[pulp::server::service]') }
  it { should contain_class('pulp::server::service').that_comes_before('Anchor[pulp::server::end]') }
  it { should contain_anchor('pulp::server::end') }

  it_behaves_like 'pulp::server::install'
  it_behaves_like 'pulp::server::config'
  it_behaves_like 'pulp::server::service'

end

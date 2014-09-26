shared_examples_for 'pulp::server::install' do

  packages = [
    'qpid-cpp-server',
    'qpid-cpp-server-store',
    'pulp-server',
    'pulp-puppet-plugins',
    'pulp-rpm-plugins',
    'pulp-selinux',
    'python-qpid',
    'python-qpid-qmf',
  ]

  packages.each do |package|
    it { should contain_package(package).with_ensure('present') }
  end

  context 'when ensure => "absent"' do
    let(:params) {{ :ensure => "absent" }}

    packages.each do |package|
      it { should contain_package(package).with_ensure('absent') }
    end
  end
end

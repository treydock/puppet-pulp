shared_examples_for 'pulp::admin_client::install' do

  packages = [
    'pulp-admin-client',
    'pulp-puppet-admin-extensions',
    'pulp-rpm-admin-extensions',
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

#
# these tests are a little concerning b/c they are hacking around the
# modulepath, so these tests will not catch issues that may eventually arise
# related to loading these plugins.
# I could not, for the life of me, figure out how to programatcally set the modulepath
$LOAD_PATH.push(
  File.join(
    File.dirname(__FILE__),
    '..',
    '..',
    '..',
    '..',
    'fixtures',
    'modules',
    'inifile',
    'lib')
)
require 'spec_helper'
provider_class = Puppet::Type.type(:pulp_consumer_config).provider(:ini_setting)
describe provider_class do
  it 'should set section and setting' do
    resource = Puppet::Type::Pulp_consumer_config.new(
      {:name => 'vars/foo', :value => 'bar'}
    )
    provider = provider_class.new(resource)
    provider.section.should == 'vars'
    provider.setting.should == 'foo'
  end
end

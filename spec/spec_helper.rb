require 'puppetlabs_spec_helper/module_spec_helper'
require 'puppet'

dir = File.expand_path(File.dirname(__FILE__))
Dir["#{dir}/support/**/*.rb"].sort.each { |f| require f }

def fixture_path
  File.join File.dirname(__FILE__), 'fixtures'
end

at_exit { RSpec::Puppet::Coverage.report! }

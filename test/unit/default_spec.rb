require 'spec_helper'

describe 'flexget::default' do

  let(:runner) {
    ChefSpec::SoloRunner.new(
      :platform => 'ubuntu',
      :version => '12.04'
    )
  }
  let(:node) { runner.node }
  let(:chef_run) { runner.converge(described_recipe) }
  let(:service_user) { 'flexget' }

  it 'installs flexget' do
    expect(chef_run).to install_python_pip('flexget')
  end

  context 'with a list of plugin dependencies' do
    before do
      chef_run.node.set[:flexget][:plugin_dependencies] = ['transmissionrpc']
      runner.converge(described_recipe)
    end
    it 'installs specified plugins' do
      expect(chef_run).to install_python_pip('transmissionrpc')
    end
  end

  it 'creates flexget data directory' do
    expect(chef_run).to create_directory('/etc/flexget')
  end

  it 'creates flexget log directory' do
    expect(chef_run).to create_directory('/var/log/flexget')
  end

  it 'creates flexget configuration yaml' do
    expect(chef_run).to create_template('/etc/flexget/config.yml')
  end

  context 'when runit service is enabled' do
    before do
      chef_run.node.set[:flexget][:service_enabled] = true
      chef_run.converge(described_recipe)
    end

    it 'enables the flexget runit service' do
      expect(chef_run).to enable_runit_service('flexget')
    end
  end

  context 'when runit service is disabled' do
    before do
      chef_run.node.set[:flexget][:service_enabled] = false
      chef_run.converge(described_recipe)
    end

    it 'disables the flexget runit service' do
      expect(chef_run).to disable_runit_service('flexget')
    end
  end
end

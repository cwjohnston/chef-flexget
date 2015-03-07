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

  it 'creates a virtualenv' do
    expect(chef_run).to create_python_virtualenv('/opt/flexget/env')
  end

  context 'without a value specified for the flexget version attribute' do
    before do
      chef_run.node.override[:flexget][:version] = nil
      chef_run.converge(described_recipe)
    end
    it 'installs the latest version of flexget' do
      expect(chef_run).to install_python_pip('flexget').with(:version => nil)
    end
  end

  context 'with a value specified for the flexget version attribute' do
    before do
      chef_run.node.override[:flexget][:version] = '3005'
      chef_run.converge(described_recipe)
    end
    it 'installs the requested version of flexget' do
      expect(chef_run).to install_python_pip('flexget').with(
        :version => '3005'
      )
    end
  end

  context 'with a hash of plugin names and versions' do
    before do
      chef_run.node.set[:flexget][:plugin_dependencies] = {
        'transmissionrpc' => nil,
        'six' => '1.7.0'
      }
      runner.converge(described_recipe)
    end
    it 'installs specified plugins' do
      expect(chef_run).to install_python_pip('transmissionrpc').with(:version => nil)
      expect(chef_run).to install_python_pip('six').with(:version => '1.7.0')
    end
  end

  it 'creates flexget data directory' do
    expect(chef_run).to create_directory('/opt/flexget')
  end

  it 'creates flexget log directory' do
    expect(chef_run).to create_directory('/var/log/flexget')
  end

  it 'creates flexget configuration yaml' do
    expect(chef_run).to create_template('/opt/flexget/config.yml')
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

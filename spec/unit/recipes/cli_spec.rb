#
# Cookbook:: dcos
# Spec:: cli
#

require 'spec_helper'

describe 'dcos::cli' do
  context 'Default behavior' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: '7').converge(described_recipe)
    end

    it 'creates remote_file[/usr/local/bin/dcos]' do
      expect(chef_run).to create_remote_file('/usr/local/bin/dcos').with(mode: '0755')
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end

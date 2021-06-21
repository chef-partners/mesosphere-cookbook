module Dcos
  # Helper functions
  module Helpers
    def dcos_generate_config_url
      return node['dcos']['dcos_generate_config_url'] if node['dcos'].key?('dcos_generate_config_url')
      return "#{dcos_base_url}/dcos_generate_config.ee.sh" if dcos_enterprise?
      "#{dcos_base_url}/dcos_generate_config.sh"
    end

    def dcos_enterprise?
      node['dcos']['dcos_enterprise'].to_s == 'true'
    end

    def dcos_cluster_address
      if node['dcos'].key?('config') && node['dcos']['config'].key?('master_discovery') &&
         node['dcos']['config']['master_discovery'] == 'master_http_loadbalancer' &&
         node['dcos']['config'].key?('master_external_loadbalancer')
        node['dcos']['config']['master_external_loadbalancer']
      elsif node['dcos'].key?('config') && node['dcos']['config'].key?('master_list')
        node['dcos']['config']['master_list'].first # yuck, we can do better
      else
        'leader.mesos' # assuming we're inside the cluster
      end
    end

    private

    def dcos_base_url
      v = node['dcos']['dcos_version']
      return 'https://downloads.dcos.io/dcos/EarlyAccess' if v.downcase == 'earlyaccess'
      if v.to_f >= 1.10
        return "https://downloads.mesosphere.com/dcos-enterprise/stable/#{v}" if dcos_enterprise?
        "https://downloads.dcos.io/dcos/stable/#{v}"
      else # stable or older releases
        return 'https://downloads.mesosphere.com/dcos-enterprise/stable/1.12.2' if dcos_enterprise?
        'https://downloads.dcos.io/dcos/stable'
      end
    end
  end
end

Chef::DSL::Recipe.send(:include, Dcos::Helpers)
Chef::Resource.send(:include, Dcos::Helpers)

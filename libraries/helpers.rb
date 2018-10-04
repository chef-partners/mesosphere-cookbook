module Dcos
  # Helper functions
  module Helpers
    def dcos_generate_config_url
      return node['dcos']['dcos_generate_config_url'] if node['dcos'].key?('dcos_generate_config_url')
      return "#{dcos_base_url}/dcos_generate_config.ee.sh" if dcos_enterprise?
      case node['dcos']['dcos_version']
      when 'EarlyAccess', 'earlyaccess'
        "#{dcos_base_url}/dcos_generate_config.sh"
      else
        "#{dcos_base_url}/commit/#{dcos_commit_id}/dcos_generate_config.sh"
      end
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
      if v.to_f >= 1.10 || v.split('.').drop(1).join('.').to_f > 9.0 || v == '1.8.9' # 1.9.0 and < 1.8.9 use else method
        return "https://downloads.mesosphere.com/dcos-enterprise/stable/#{v}" if dcos_enterprise?
        return "https://downloads.dcos.io/dcos/stable/#{v}"
      else # stable or older releases
        return 'https://downloads.mesosphere.com/dcos-enterprise/stable/1.11.6' if dcos_enterprise?
        'https://downloads.dcos.io/dcos/stable'
      end
    end

    def dcos_commit_id
      case node['dcos']['dcos_version']
      when 'stable', '1.11.6'
        '521b01b736505a610bb98d715bdf847a7e8223b6'
      when '1.11.5'
        'b202c9098211e1ba92d2b88d17caf418d36795a5'
      when '1.11.4'
        '8ecb7913da270b9422c9a563ce16578a355cecbb'
      when '1.11.3'
        '96f364a598e5f06371794ebb7c40fff65d0c289f'
      when '1.11.2'
        'e871b90b33ba43478f6ba904b7289ffbf79550dd'
      when '1.11.1'
        'fefb2e4d76f397d84f450086b14eba6ca7572cd7'
      when '1.11.0'
        'b6d6ad4722600877fde2860122f870031d109da3'
      when '1.10.8'
        '61de47be4a8588ee5c4168ec297ad2135d5e5ed1'
      when '1.10.7'
        '609e7b7e06a23e85a9dfaa67fdbc52ca8b5ac95b'
      when '1.10.6'
        '2a37eea95cc4a64ede4074cc9b6d6d2844c647b0'
      when '1.10.5'
        '5831285e56a88d3f54446a987a0384f915832f40'
      when '1.10.4'
        '2d45a8f9e277a60007f277f70f01d076c913a7fe'
      when '1.10.2'
        '12b494a3309c65a22b7d5553debd1c053e008a31'
      when '1.10.1'
        'd932fc405eb80d8e5b3516eaabf2bd41a2c25c9f'
      when '1.10.0'
        'e38ab2aa282077c8eb7bf103c6fff7b0f08db1a4'
      when '1.9.10'
        'afa41d022b61a1b6e5723799ec6617c90621cf8a'
      when '1.9.9'
        'e52b4e2452970d45a39183bfd0260fb28bd920b6'
      when '1.9.8'
        'd1e4db6b234cd3d0b54d2be04b0b088f72870d88'
      when '1.9.7'
        '888d171dbd85d2a56cc046b95c751989ea6c7604'
      when '1.9.6'
        'f25e9dcfd0abae4de8bc18cc1fc9584a7a0a586a'
      when '1.9.5'
        '4308d88bfc0dd979703f4ef500ce415c5683b3c5'
      when '1.9.4'
        'ff2481b1d2c1008010bdc52554f872d66d9e5904'
      when '1.9.3'
        '744f5ea28fc52517e344a5250a5fd12554da91b8'
      when '1.9.2'
        'af6ddc2f5e95b1c1d9bd9fd3d3ef1891928136b9'
      when '1.9.1'
        '008d3bfe4acca190100fcafad9a18a205a919590'
      when '1.9.0'
        '0ce03387884523f02624d3fb56c7fbe2e06e181b'
      when '1.8.9'
        '65d66d7f399fe13bba8960c1f2c42ef9fa5dcf8d'
      when '1.8.8'
        '602edc1b4da9364297d166d4857fc8ed7b0b65ca'
      when '1.8.7'
        '1b43ff7a0b9124db9439299b789f2e2dc3cc086c'
      end
    end
  end
end

Chef::Recipe.send(:include, Dcos::Helpers)
Chef::Resource.send(:include, Dcos::Helpers)

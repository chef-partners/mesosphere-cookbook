#
# Author:: Matt Ray <matt@chef.io>
# Cookbook:: dcos
#
# Copyright:: 2016 Chef Software, Inc
# Copyright:: 2017-2018 Chris Gianelloni
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# DC/OS Edition/Version Setup
default['dcos']['dcos_earlyaccess'] = false
default['dcos']['dcos_version'] = node['dcos']['dcos_earlyaccess'] ? 'earlyaccess' : 'stable'
default['dcos']['dcos_enterprise'] = false

# DC/OS role
default['dcos']['dcos_role'] = 'master' # 'master', 'slave' or 'slave_public'

# DC/OS license (Enterprise only, 1.11+)
default['dcos']['dcos_license_text'] = nil

# DC/OS config.yaml
default['dcos']['config']['bootstrap_url'] = 'file:///usr/src/dcos/genconf/serve'
default['dcos']['config']['cluster_name'] = 'DCOS'
default['dcos']['config']['exhibitor_storage_backend'] = 'static'
default['dcos']['config']['master_discovery'] = 'static'
# ipv4 only, must be odd number 1-9
default['dcos']['config']['master_list'] = []
# upstream DNS for MesosDNS
default['dcos']['config']['resolvers'] = ['8.8.8.8', '8.8.4.4']
default['dcos']['config']['security'] = 'permissive' if node['dcos']['dcos_enterprise']

default['dcos']['manage_docker'] = true
default['dcos']['docker_storage_driver'] = 'overlay'
default['dcos']['docker_version'] = nil

# Number of times to poll for leader.mesos before giving up
default['dcos']['leader_check_retries'] = 120

# determine how to generate the genconf/ip-detect script
# 'aws' or 'gce' will use the local ipv4 address from the metadata service
# otherwise use 'eth0', 'eth1', etc. and it will get the ipaddress associated
# with node['network']['interface'][VALUE]
default['dcos']['ip-detect'] = 'eth0'

# Override this to use a file from another cookbook
default['dcos']['ip-detect-public']['cookbook'] = 'dcos'
default['dcos']['ip-detect-public']['source'] = 'ip-detect-public'
default['dcos']['fault-domain-detect']['cookbook'] = 'dcos'
default['dcos']['fault-domain-detect']['source'] = 'fault-domain-detect'

#
# Cookbook:: dcos
# Recipe:: _ip-detect
#
# Copyright:: 2016, Chef Software, Inc.
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

# generates a genconf/ip-detect script based on the node['dcos']['ip-detect']
# https://docs.mesosphere.com/archived-dcos-enterprise-edition/installing-enterprise-edition-1-5/create-a-script-for-ip-address-discovery/

if %w(aws gce).include?(node['dcos']['ip-detect'])
  cookbook_file '/usr/src/dcos/genconf/ip-detect' do
    source node['dcos']['ip-detect']
    mode '0755'
  end
  cookbook_file '/usr/src/dcos/genconf/ip-detect-public' do
    source "#{node['dcos']['ip-detect']}_public"
    mode '0755'
  end
else
  # find the ipaddress for that interface
  interface = node['dcos']['ip-detect']
  template '/usr/src/dcos/genconf/ip-detect' do
    source 'ip-detect.erb'
    mode '0755'
    variables(interface: interface)
  end
  cookbook_file '/usr/src/dcos/genconf/ip-detect-public' do
    cookbook node['dcos']['ip-detect-public']['cookbook']
    source node['dcos']['ip-detect-public']['source']
    mode '0755'
    not_if { node['dcos']['ip-detect-public']['source'].nil? }
  end
end

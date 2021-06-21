#
# Cookbook:: dcos
# Recipe:: cli
#
# Copyright:: 2018 Chris Gianelloni
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

cli_base_url = "https://downloads.dcos.io/binaries/cli/#{node['os']}/#{node['kernel']['machine'].tr('_', '-')}"

# Fetch the `dcos` CLI tool
remote_file '/usr/local/bin/dcos' do
  source "#{cli_base_url}/dcos-#{node['dcos']['dcos_version'].to_f}/dcos"
  mode '0755'
end

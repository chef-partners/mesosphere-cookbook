#
# Cookbook:: dcos
# Recipe:: default
#
# Copyright:: 2018, Chef Software, Inc.
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

resource_name :dcos_user
unified_mode true
provides :dcos_user

property :zk_host, String,
         required: true
property :email, String, required: false

load_current_value do
  require 'zookeeper'
  include Zookeeper::Constants
  z = Zookeeper.new(zk_host)
  user_node = z.get(path: "/dcos/users/#{email}")
  email user_node[:data] if user_node[:rc] == ZOK
end

action :create do
  # If there is a change, remove and replace the current data
  converge_if_changed :email do
    require 'zookeeper'
    include Zookeeper::Constants
    z = Zookeeper.new(zk_host)
    z.delete(path: "/dcos/users/#{email}") # Fails cleanly if it doesn't exist.
    z.create(path: "/dcos/users/#{email}", data: email)
  end
end

action :delete do
  require 'zookeeper'
  include Zookeeper::Constants
  # Remove the user node from Zookeeper
  z = Zookeeper.new(zk_host)
  z.delete(path: "/dcos/users/#{email}")
end

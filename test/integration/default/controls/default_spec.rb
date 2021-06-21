#
# Copyright:: (c) 2017 Chris Gianelloni
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

%w(
  firewalld
  rsyslog
).each do |svc|
  describe service(svc) do
    it { should_not be_running }
    it { should_not be_enabled }
  end
end

%w(
  curl
  ipset
  tar
  unzip
  xz
).each do |pkg|
  describe package(pkg) do
    it { should be_installed }
  end
end

describe group('nobody') do
  it { should exist }
end

describe directory('/opt/mesosphere') do
  it { should exist }
  it { should be_directory }
  it { should be_readable }
end

describe file('/opt/mesosphere/environment') do
  it { should exist }
  it { should be_file }
  it { should be_readable }
end

describe file('/etc/profile.d/dcos.sh') do
  it { should exist }
  it { should be_file }
  it { should be_readable }
  it { should be_symlink }
end

target_file = file('/etc/profile.d/dcos.sh').link_path
describe file(target_file) do
  it { should exist }
  it { should be_file }
  it { should be_readable }
end

%w(
  docker
  dcos-exhibitor
  dcos-marathon
  dcos-mesos-master
).each do |svc|
  describe service(svc) do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
end

describe file('/etc/mesosphere/roles/master') do
  it { should exist }
  it { should be_readable }
end

%w(
  slave
  slave_public
).each do |role|
  describe file("/etc/mesosphere/roles/#{role}") do
    it { should_not exist }
  end
end

%w(
  /etc/mesosphere/setup-flags/repository-url
).each do |conf|
  describe file(conf) do
    it { should exist }
    it { should be_readable }
  end
end

describe yaml('/etc/rexray/config.yml') do
  its(%w(rexray modules default-docker disabled)) { should eq true }
end

# IPv4 (TCP + UDP)
describe port(53) do
  it { should be_listening }
  its('protocols') { should include 'tcp' }
  its('protocols') { should include 'udp' }
end

# IPv4 (TCP + TCP6)
%w(
  80
  443
  2181
  5050
  8080
  8181
).each do |tcp|
  describe port(tcp) do
    it { should be_listening }
    its('protocols') { should cmp(/tcp/) }
  end
end

name             'dcos'
maintainer       'Chef Software, Inc.'
maintainer_email 'partnereng@chef.io'
license          'Apache-2.0'
description      'Installs/Configures Mesosphere DC/OS'
version          '3.0.1'

source_url 'https://github.com/chef-partners/dcos-cookbook'
issues_url 'https://github.com/chef-partners/dcos-cookbook/issues'
chef_version '>= 12.10'

%w(
  centos
  oracle
  redhat
  scientific
).each do |distro|
  supports distro
end

depends 'docker', '~> 4.4'
depends 'selinux', '~> 2.1'

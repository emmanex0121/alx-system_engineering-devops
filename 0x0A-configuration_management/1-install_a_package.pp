#!/usr/bin/pup
# installing a specific version of flask 2.1.0

package { 'python3-pip':
  ensure => installed,
}

exec { 'Flask':
  command => '/usr/bin/pip3 install flask=2.1.0',
  path    => ['/usr/bin'],
  unless  => '/usr/bin/pip3 show Flask | grep -q "Version: 2.1.0"',
}

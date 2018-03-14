$docker_path = [
  '/home/docker/observium/db',
  '/home/docker/observium/lock',
  '/home/docker/observium/mysql',
]
# docker packages
package { 'docker.io':
  ensure => latest,
}
package { 'docker-compose':
  ensure  => latest,
  require => Package['docker.io'],
}
# docker directory
file { '/home/docker':
  ensure  => directory,
  owner   => root,
  group   => root,
}
file { '/home/docker/observium':
  ensure  => directory,
  owner   => root,
  group   => root,
}
file { $docker_path:
  ensure  => present,
  owner   => root,
  group   => root,
  require => File['/home/docker/observium'],
}
service { 'docker':
  ensure  => running,
  require => Package['docker.io'],
}

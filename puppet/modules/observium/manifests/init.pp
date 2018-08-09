# install observium
class observium {
  $docker_path = [
    '/home/docker/observium/db',
    '/home/docker/observium/lock',
    '/home/docker/observium/mysql',
  ]
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
}
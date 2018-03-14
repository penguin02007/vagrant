package { 'docker.io':
  ensure => running,
}

package { 'docker-compose'
  ensure  => running,
  require => Package ['docker.io'],
}

file { 
  [
    '/home/docker/observium/db',
    '/home/docker/observium/lock',
    '/home/docker/observium/mysql',
  ]
}

file { '/home/docker/observium/docker-compose.yml'
  content => download_content(\
    'https://raw.githubusercontent.com/somsakc/docker-observium/master/amd64/docker-compose.yml')
}
class docker {
  package { 'docker.io':
    ensure => latest,
  }
  package { 'docker-compose':
    ensure  => latest,
    require => Package['docker.io'],
  }
  service { 'docker':
    ensure  => running,
    require => Package['docker.io'],
  }
}

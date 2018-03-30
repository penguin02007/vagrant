package { 'docker.io':
  ensure => latest,
}
package { 'docker-compose':
  ensure  => latest,
  require => Package['docker.io'],
}

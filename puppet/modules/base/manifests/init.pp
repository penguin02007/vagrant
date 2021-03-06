# base class for all nodes
class base {
  $bootstrap_packages = [
    'python-apt',
    'python-minimal',
  ]
  # ubuntu only
  Exec { path => ['/usr/bin'] } 
  @exec { 'apt-get update':
     tag => apt-get_update
  }
  notice("Running bootstrap...")
  package { $bootstrap_packages :
    ensure => latest,
  }

  file {'/etc/hosts':
    ensure => 'file',
    content => template('base/hosts.erb'),
  }

  Exec <| tag == apt-get_update |> -> Package <| |>
}

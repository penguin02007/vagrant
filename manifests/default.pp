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

Exec <| tag == apt-get_update |> -> Package <| |>
